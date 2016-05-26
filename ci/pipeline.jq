{
  "jobs": [
    {
      "name": "update-infra-stack",
      "serial": true,
      "plan": [
        {
          "aggregate": [
            {
              "get": "env"
            },
            {
              "get": "infra-env",
              "trigger": true,
            }
          ]
        },
        {
          "task": "render-stack",
          "file": "env/ci/tasks/infra/cloudformation-render.yml"
        },
        {
          "put": "infra-stack",
          "params": {
            "template": "render/cloudformation.json"
          }
        }
      ]
    },
    {
      "name": "update-bosh-stack",
      "serial": true,
      "plan": [
        {
          "aggregate": [
            {
              "get": "env"
            },
            {
              "get": "bosh-env",
              "trigger": true
            },
            {
              "get": "infra-stack",
              "trigger": true
            }
          ]
        },
        {
          "task": "render-stack",
          "file": "env/ci/tasks/bosh/cloudformation-render.yml"
        },
        {
          "put": "bosh-stack",
          "params": {
            "template": "render/cloudformation.json",
            "capabilities": [
              "CAPABILITY_IAM"
            ]
          }
        }
      ]
    },
    {
      "name": "update-bosh",
      "serial": true,
      "plan": [
        {
          "aggregate": [
            {
              "get": "env"
            },
            {
              "get": "infra-stack",
              "trigger": true,
              "passed": [
                "update-infra-stack"
              ]
            },
            {
              "get": "bosh-stack",
              "trigger": true,
              "passed": [
                "update-bosh-stack"
              ]
            },
            {
              "get": "bosh-env",
              "trigger": true
            }
          ]
        },
        {
          "task": "render-manifest",
          "file": "env/ci/tasks/bosh/bosh-init-render.yml",
          "params": {
            "access_key": env.AWS_ACCESS_KEY_ID,
            "secret_key": env.AWS_SECRET_ACCESS_KEY
          }
        },
        {
          "task": "update-bosh",
          "file": "env/ci/tasks/bosh/create/config.yml",
          "input_mapping": {
            "input": "render"
          },
          "params": {
            "ssh_key": $config_aws_pem,
            "state_file": "bosh/bosh-init-state.json"
          },
          "ensure": {
            "put": "env",
            "params": {
              "rebase": true,
              "repository": "env"
            }
          }
        }
      ]
    },
    {
      "name": "update-bosh-cloud-config",
      "serial": true,
      "plan": [
        {
          "aggregate": [
            {
              "get": "env"
            },
            {
              "get": "infra-env",
              "trigger": true
            },
            {
              "get": "infra-stack",
              "trigger": true,
              "passed": [
                "update-infra-stack"
              ]
            },
            {
              "get": "bosh-env",
              "trigger": true,
              "passed": [
                "update-bosh"
              ]
            },
            {
              "get": "bosh-stack",
              "trigger": true,
              "passed": [
                "update-bosh-stack"
              ]
            },
            {
              "get": "cf-stack",
              "trigger": true
            },
            {
              "get": "cf-env",
              "trigger": true
            }
          ]
        },
        {
          "task": "cloud-config",
          "file": "env/ci/tasks/bosh/cloud-config/config.yml",
        }
      ]
    },
    {
      "name": "update-cf-stack",
      "serial": true,
      "plan": [
        {
          "aggregate": [
            {
              "get": "env"
            },
            {
              "get": "bosh-env"
            },
            {
              "get": "infra-stack",
              "trigger": true,
              "passed": [
                "update-infra-stack"
              ]
            },
            {
              "get": "cf-env",
              "trigger": true
            }
          ]
        },
        {
          "task": "render-stack",
          "file": "env/ci/tasks/cf/cloudformation-render.yml"
        },
        {
          "put": "cf-stack",
          "params": {
            "template": "render/cloudformation.json",
            "capabilities": [
              "CAPABILITY_IAM"
            ]
          }
        }
      ]
    },
    {
      "name": "update-cf-deployment",
      "serial": true,
      "plan": [
        {
          "aggregate": [
            {
              "get": "env"
            },
            {
              "get": "cf-env",
              "trigger": true,
              "passed": [
                "update-cf-stack",
                "update-bosh-cloud-config"
              ]
            },
            {
              "get": "cf-stack",
              "trigger": true,
              "passed": [
                "update-cf-stack"
              ]
            }
          ]
        },
        {
          "task": "render-stack",
          "file": "env/ci/tasks/cf/bosh-render.yml"
        },
        {
          "put": "cf-deployment",
          "params": {
            "target_file": "env/bosh/director",
            "manifest": "render/bosh.json",
            "stemcells": [],
            "releases": []
          }
        }
      ]
    }
  ],
  "resources": [
    {
      "name": "infra-stack",
      "type": "aws-cloudformation-stack",
      "source": {
        "name": ( $env.name + "-infra" ),
        "region": env.AWS_DEFAULT_REGION,
        "access_key": env.AWS_ACCESS_KEY_ID,
        "secret_key": env.AWS_SECRET_ACCESS_KEY
      }
    },
    {
      "name": "bosh-stack",
      "type": "aws-cloudformation-stack",
      "source": {
        "name": ( $env.name + "-bosh" ),
        "region": env.AWS_DEFAULT_REGION,
        "access_key": env.AWS_ACCESS_KEY_ID,
        "secret_key": env.AWS_SECRET_ACCESS_KEY
      }
    },
    {
      "name": "cf-stack",
      "type": "aws-cloudformation-stack",
      "source": {
        "name": ( $env.name + "-cf" ),
        "region": env.AWS_DEFAULT_REGION,
        "access_key": env.AWS_ACCESS_KEY_ID,
        "secret_key": env.AWS_SECRET_ACCESS_KEY
      }
    },
    {
      "name": "cf-deployment",
      "type": "bosh-deployment",
      "source": {
        "username": ( env.BOSH_USERNAME // "admin" ),
        "password": ( env.BOSH_PASSWORD // "admin" ),
        "deployment": "cf",
        "zca_cert": $config_bosh_ca_crt
      }
    },
    {
      "name": "env",
      "type": "git",
      "source": {
        "uri": $env.repo_uri,
        "branch": $env.repo_branch,
        "private_key": $config_repo_pem
      }
    },
    {
      "name": "infra-env",
      "type": "git",
      "source": {
        "uri": $env.repo_uri,
        "branch": $env.repo_branch,
        "private_key": $config_repo_pem,
        "paths": [
          "infra/"
        ]
      }
    },
    {
      "name": "bosh-env",
      "type": "git",
      "source": {
        "uri": $env.repo_uri,
        "branch": $env.repo_branch,
        "private_key": $config_repo_pem,
        "paths": [
          "bosh/"
        ]
      }
    },
    {
      "name": "cf-env",
      "type": "git",
      "source": {
        "uri": $env.repo_uri,
        "branch": $env.repo_branch,
        "private_key": $config_repo_pem,
        "paths": [
          "cf/"
        ]
      }
    }
  ],
  "resource_types": [
    {
      "name": "aws-cloudformation-stack",
      "type": "docker-image",
      "source": {
        "repository": "dpb587/aws-cloudformation-stack-resource",
        "tag": "master"
      }
    }
  ]
}
