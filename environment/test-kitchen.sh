# Test kitchen aliases
export TEST_KITCHEN="$(which kitchen)"

if [ -s "${TEST_KITCHEN}" ]; then
  tkl() {
    if [ $# -gt 0 ]; then
      ${TEST_KITCHEN} login ${*}
    else
      ${TEST_KITCHEN} list
    fi
  }

  tkcil() {
    if [ $# -gt 0 ]; then
      KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} login ${*}
    else
      KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} list
    fi
  }

  alias tkt="${TEST_KITCHEN} test"
  alias tkv="${TEST_KITCHEN} verify"
  alias tkc="${TEST_KITCHEN} converge"
  alias tkd="${TEST_KITCHEN} destroy"
  alias tke="${TEST_KITCHEN} exec"

  # CI harness
  alias tkci="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN}"
  alias tkcit="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} test"
  alias tkciv="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} verify"
  alias tkcic="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} converge"
  alias tkcid="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} destroy"
  alias tkcie="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} exec"
fi