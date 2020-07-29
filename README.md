## nightly_deployment: latest build & KNIME integration test

### This project serves two purposes:
- providing an update site on bintray for the latest FSK-Lab build: 
  - once per day (CRON job) FSK-Lab (master branch) is build by https://travis-ci.org/ 
  - and deployed on the update site: https://dl.bintray.com/silebat/nightly
- performing a number of integration tests:
  - check, if new FSK-Lab build can be installed into KNIME 3.7.2 & KNIME 4.1.2
  - check, if existing FSK-Lab installation can be updated to newest one
  - a number of KNIME test workflows are executed to make sure, the new build still runs existing workflows & models
  - all checks are done for Windows (win32_x64) & Linux (x64)
  
### KNIME Integration Tests

- the KNIME test workflows for FSK-Lab are available here: https://dl.bintray.com/silebat/build_pipeline_test_wf
