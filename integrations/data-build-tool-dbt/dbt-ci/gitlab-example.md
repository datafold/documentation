# GitLab example

A simple example pipeline using GitLab CI. In this example, we have a production and development environment. The production environment runs from the default branch, and the development from pull requests:

```python
image:
  name: fishtownanalytics/dbt:0.20.0
  entrypoint: [ "" ]

run_pipeline:
  stage: deploy
  before_script:
    - pip install datafold-sdk
  script:
    - set -ex
    - dbt seed --full-refresh --profiles-dir ./
    - dbt run --profiles-dir ./
    - datafold dbt upload --ci-config-id 21 --run-type $TYPE --target-folder ./target/
  rules:
    - if: $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH
      variables:
        TYPE: "production"
        SNOWFLAKE_SCHEMA: "BEERS"
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      variables:
        TYPE: "pull_request"
        SNOWFLAKE_SCHEMA: "BEERS_DEV"

post_check:
  stage: dbt-check-artifacts
  before_script:
    - pip install datafold-sdk
  script:
    - datafold dbt check-post-upload-dbt-artifacts --ci-config-id 21 --run-type $TYPE --branch $CI_COMMIT_REF_NAME --commit-sha $CI_COMMIT_SHA
  rules:
    - if: $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH
      variables:
        TYPE: "production"
      when: always
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      variables:
        TYPE: "pull_request"
      when: always            
```

This is a [minimal pipeline example](https://gitlab.com/datafold/dbt-snowflake) that will run the development pipeline in the `BEERS_DEV` schema, and the production one on `BEERS`. When you will create a pull request, Datafold will perform a data diff and push this on the Pull Request in GitLab.
