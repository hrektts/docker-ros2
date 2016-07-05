#!/usr/bin/env bats

@test "initialize" {
    run docker run --label bats-type="test" --name bats-ros2 --privileged \
        -d hrektts/ros2:bats tail -f /dev/null
    [ "${status}" -eq 0 ]
}

@test "underlay test" {
    run docker exec bats-ros2 \
        bash -c "echo 'root - memlock unlimited' >> /etc/security/limits.conf"
    [ "${status}" -eq 0 ]

    run docker exec bats-ros2 \
        bash -c "echo 'ulimit -l unlimited' >> /root/.bashrc"
    [ "${status}" -eq 0 ]

    run docker exec bats-ros2 \
        /root/ros2_ws/src/ament/ament_tools/scripts/ament.py test ${TEST_BASEPATH}
    [ "${status}" -eq 0 ]
}

@test "cleanup" {
    CIDS=$(docker ps -q --filter "label=bats-type")
    if [ ${#CIDS[@]} -gt 0 ]; then
        run docker stop ${CIDS[@]}
        run docker rm ${CIDS[@]}
    fi
}
