# cfsummit-bosh-jq

An example of using [`jq`](https://stedolan.github.io/jq/) to help abstract and compose manifests for BOSH and letting Concourse deploy changes. This was presented with [slides](https://docs.google.com/presentation/d/1PiiO6ckMY5xZDJHcpu4JjpOMZu_F04D8Sd-krVv1rG0/view) as a Lightning Talk at CF Summit on May 26, 2016. It was based on my earlier blog post, [Composing Configurations with JQ](https://dpb587.me/blog/2016/04/26/composing-configurations-with-jq.html). See the slides, read the post, or ask me for a walkthrough.

Caveat emptor...

 * this repo is for demo purposes only; the scripts here are the ones based off my actual environments using jq
 * it spins up actual instances you will be charged for
 * it's not well secured; deployments are only limited to your IPs
 * I don't know CF release; it deploys and you can deploy an app, but something's still misconfigured; based on [minimal-aws.yml](https://github.com/cloudfoundry/cf-release/blob/master/example_manifests/minimal-aws.yml)
 * it's a demo repository... proof of concept... spike
 * it doesn't have a one-click tear down; deploy it to a test region, then you can just select all EC2 instances and terminate them, then delete the 3 CloudFormation stacks this makes

Points of interest...

 * [`ci/bin/render`](ci/bin/render) - takes your JQ-manifest, loads the *-stack files and ./config/* files as arguments, renders and outputs your manifest
 * [`ci/tasks/bosh/bosh-init-render.yml`](ci/tasks/bosh/bosh-init-render.yml) - tasks for rendering your manifests; you're forced to explicitly list what the manifests depend on so bots know what to do
 * [`ci/pipeline.jq`](ci/pipeline.jq) - the pipeline; kind of messy due to odd dependencies, but in theory this could be generated from task configs and conventions
 * [`bosh/cloudformation.jq`](bosh/cloudformation.jq) - a JQ-friendly AWS CloudFormation which references the original infrastructure stack (VPC ID)
 * [`bosh/bosh-init.jq`](bosh/bosh-init.jq) - example of referencing certificates, file-based credentials, and CloudFormation stack results
 * [`bosh/generate-config`](bosh/generate-config) - a deployment knowing how to generate its own "secure" default settings
 * jq can reference environment variables - rely on default AWS environment variables rather than user needing to hard-code credentials to files
 

## Demo

**Prerequisites**:

 * `git`, `fly`, `jq`, `openssl`, `cf`, `go`
 * Concourse server which deploys everything for you (try [concourse-lite](https://github.com/concourse/concourse-lite))
 * A private git repository/branch and private key for your CI to access it - bosh-init will update its state file and commit/push it to the repo
 * AWS Route 53 domain for testing CF
 * AWS environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`) - these are only used by concourse for bosh-init and stack management; bosh-init provisions with these credentials, but BOSH director will use an IAM role instead of keys
 * AWS SSH key pair for you and your CI to access VMs - bosh-init uses this key while provisioning BOSH director

Clone this repo and create your own git repository/branch from it...

    $ mkdir cfsummit-bosh-jq
    $ wget -qO- https://github.com/dpb587/cfsummit-bosh-jq-demo/archive/master.tgz | tar -xzf- --strip-components 1
    $ git init . && git add -A . && git commit -m 'new environment'

Symlink to your git repository and AWS keys and configure the AWS keypair name...

    $ ln -s ~/.ssh/github_rsa ci/config/repo.pem
    $ ln -s ~/.ssh/aws_rsa ci/config/aws.pem
    $ ci/bin/jsonconfig set env.json ssh_key_name "{{example = default}}"

Configure which repository/branch you're using...

    $ ci/bin/jsonconfig set env.json repo_uri "{{example = git@github.com:whoami/myenv.git}}"
    $ git remote add origin "$( ci/bin/jsonconfig get env.json repo_uri )"

Configure the Route 53 domain and hostname to use for the CF deployment...

    $ ci/bin/jsonconfig set cf/config/settings.json fqdn_zone "{{example = example.com}}"
    $ ci/bin/jsonconfig set cf/config/settings.json system_domain "{{example = cfsummit-bosh-jq.example.com}}"

Regenerate random passwords and keys for your environment, then commit and push...

    $ ./ci/bin/generate-config
    $ git add -A . && git commit -m 'customize environment' && git push

Now deploy the pipeline to Concourse (this will actually start creating resources and AWS will charge you money!)...

    $ ./ci/bin/deploy $FLY_TARGET

Once the pipeline has finished... you can deploy something to it...

    # target, login, prepare
    $ cf target --skip-ssl-validation api.$( ci/bin/jsonconfig get cf/config/settings.json system_domain )
    $ cf login -u admin -p PASSWORD
    $ cf create-space test
    $ cf target -s test
    
    # use the sample dora app
    $ git clone git clone https://github.com/cloudfoundry/cf-acceptance-tests.git
    $ cd cf-acceptance-tests/assets/dora
    $ cf push doratest
    
    # see it
    $ open http://doratest.$( ci/bin/jsonconfig get cf/config/settings.json system_domain )


## Links

 * [jq](https://stedolan.github.io/jq/)
 * [aws-cloudformation-stack-resource](https://github.com/dpb587/aws-cloudformation-stack-resource) (soon to be merged back to [pivotal-cf-experimental/cloudformation-resource](https://github.com/pivotal-cf-experimental/cloudformation-resource))
 * [Concourse](http://concourse.ci/)
 

## License

[MIT License](./LICENSE)
