{
  "name": $env.name,
  "releases": $config_releases,
  "networks": [
    {
      "name": "bosh",
      "type": "manual",
      "subnets": [
        {
          "range": "10.0.0.0/24",
          "gateway": "10.0.0.1",
          "cloud_properties": {
            "subnet": $infra_stack.SubnetZ1PublicId
          },
          "static": [
            "10.0.0.5"
          ]
        }
      ]
    },
    {
      "name": "vip",
      "type": "vip"
    }
  ],
  "resource_pools": [
    {
      "name": "bosh",
      "network": "bosh",
      "stemcell": $config_stemcell | { url, sha1 },
      "cloud_properties": {
        "instance_type": "t2.medium",
        "iam_instance_profile": $bosh_stack.DirectorInstanceProfileId,
        "ephemeral_disk": {
          "size": 16384,
          "type": "standard"
        },
        "availability_zone": $infra_stack_outputs.NameZ1
      }
    }
  ],
  "disk_pools": [
    {
      "name": "bosh",
      "disk_size": 16384,
      "cloud_properties": {
        "type": "standard"
      }
    }
  ],
  "jobs": [
    {
      "name": "bosh",
      "instances": 1,
      "templates": [
        {
          "release": "bosh",
          "name": "nats"
        },
        {
          "release": "bosh",
          "name": "powerdns"
        },
        {
          "release": "bosh",
          "name": "postgres"
        },
        {
          "release": "bosh",
          "name": "blobstore"
        },
        {
          "release": "bosh",
          "name": "director"
        },
        {
          "release": "bosh",
          "name": "health_monitor"
        },
        {
          "release": "bosh",
          "name": "registry"
        },
        {
          "release": "bosh-aws-cpi",
          "name": "aws_cpi"
        }
      ],
      "resource_pool": "bosh",
      "persistent_disk_pool": "bosh",
      "networks": [
        {
          "name": "vip",
          "static_ips": [
            $bosh_stack.PublicEipId
          ]
        },
        {
          "name": "bosh",
          "default": [
            "dns",
            "gateway"
          ],
          "static_ips": [
            "10.0.0.5"
          ]
        }
      ],
      "properties": {
        "aws": {
          "credentials_source": "env_or_profile",
          "default_key_name": $env.ssh_key_name,
          "default_security_groups": [
            $bosh_stack.InstanceSecurityGroupId,
            $infra_stack.GatewaySecurityGroupId
          ],
          "region": $infra_stack_outputs.Region
        },
        "dns": {
          "recursor": "169.254.169.253",
          "db": {
            "host": "127.0.0.1",
            "user": $config_credentials.postgres_user,
            "password": $config_credentials.postgres_password,
            "database": "bosh",
            "adapter": "postgres"
          },
        },
        "nats": {
          "address": "127.0.0.1",
          "user": $config_credentials.nats_user,
          "password": $config_credentials.nats_password
        },
        "postgres": {
          "host": "127.0.0.1",
          "user": $config_credentials.postgres_user,
          "password": $config_credentials.postgres_password,
          "database": "bosh",
          "adapter": "postgres"
        },
        "registry": {
          "address": "10.0.0.5",
          "host": "10.0.0.5",
          "db": {
            "host": "127.0.0.1",
            "user": $config_credentials.postgres_user,
            "password": $config_credentials.postgres_password,
            "database": "bosh",
            "adapter": "postgres"
          },
          "http": {
            "user": $config_credentials.registry_user,
            "password": $config_credentials.registry_password,
            "port": 25777
          },
          "username": $config_credentials.registry_user,
          "password": $config_credentials.registry_password,
          "port": 25777
        },
        "blobstore": {
          "address": "10.0.0.5",
          "port": 25250,
          "provider": "dav",
          "director": {
            "user": $config_credentials.blobstore_agent_user,
            "password": $config_credentials.blobstore_agent_password
          },
          "agent": {
            "user": $config_credentials.blobstore_agent_user,
            "password": $config_credentials.blobstore_agent_password
          }
        },
        "director": {
          "address": "127.0.0.1",
          "name": $env.name,
          "enable_snapshots": false,
          "db": {
            "host": "127.0.0.1",
            "user": $config_credentials.postgres_user,
            "password": $config_credentials.postgres_password,
            "database": "bosh",
            "adapter": "postgres"
          },
          "cpi_job": "aws_cpi",
          "max_threads": 10,
          "zssl": {
            "key": $config_ssl_director_key,
            "cert": $config_ssl_director_crt,
          }
        },
        "hm": {
          "director_account": {
            "ca_cert": $config_ssl_ca_crt,
            "user": $config_credentials.hm_director_user,
            "password": $config_credentials.hm_director_password
          },
          "http": {
            "user": $config_credentials.hm_http_user,
            "password": $config_credentials.hm_http_password
          },
          "loglevel": "warn",
          "resurrector_enabled": true
        },
        "agent": {
          "mbus": ( "nats://" + $config_credentials.nats_user + ":" + $config_credentials.nats_password + "@10.0.0.5:4222" )
        },
        "ntp": [
          "0.pool.ntp.org",
          "1.pool.ntp.org",
          "2.pool.ntp.org",
          "3.pool.ntp.org"
        ]
      }
    }
  ],
  "cloud_provider": {
    "template": {
      "release": "bosh-aws-cpi",
      "name": "aws_cpi"
    },
    "ssh_tunnel": {
      "host": $bosh_stack.PublicEipId,
      "port": 22,
      "user": "vcap",
      "private_key": "id_rsa"
    },
    "mbus": ( "https://" + $config_credentials.mbus_user + ":" + $config_credentials.mbus_password + "@" + $bosh_stack.PublicEipId + ":6868" ),
    "properties": {
      "aws": {
        "access_key_id": env.access_key,
        "secret_access_key": env.secret_key,
        "default_key_name": $env.ssh_key_name,
        "default_security_groups": [
          $bosh_stack.DirectorSecurityGroupId,
          $infra_stack.GatewayInstanceSecurityGroupId
        ],
        "region": $infra_stack_outputs.Region
      },
      "agent": {
        "mbus": ( "https://" + $config_credentials.mbus_user + ":" + $config_credentials.mbus_password + "@0.0.0.0:6868" )
      },
      "blobstore": {
        "provider": "local",
        "path": "/var/vcap/micro_bosh/data/cache"
      },
      "ntp": [
        "0.pool.ntp.org",
        "1.pool.ntp.org",
        "2.pool.ntp.org",
        "3.pool.ntp.org"
      ]
    }
  }
}
