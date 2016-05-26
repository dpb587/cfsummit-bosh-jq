{
  "name": "cf",
  "releases": $config_releases,
  "stemcells": [
    { "alias": "default" } + $config_stemcell
  ],
  "update": {
    "canaries": 1,
    "max_in_flight": 1,
    "serial": false,
    "canary_watch_time": "5000-300000",
    "update_watch_time": "5000-300000"
  },
  "instance_groups": [
    {
      "name": "nats",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "nats",
          "release": "cf"
        },
        {
          "name": "nats_stream_forwarder",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private",
          "static_ips": [
            "10.0.4.13"
          ]
        }
      ]
    },
    {
      "name": "etcd",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "persistent_disk_type": "standard_128",
      "jobs": [
        {
          "name": "etcd",
          "release": "cf"
        },
        {
          "name": "etcd_metrics_server",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private",
          "static_ips": [
            "10.0.4.14"
          ]
        }
      ],
      "properties": {
        "etcd_metrics_server": {
          "nats": {
            "machines": [
              "10.0.16.13"
            ],
            "password": "PASSWORD",
            "username": "nats"
          }
        }
      }
    },
    {
      "name": "consul",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "persistent_disk_type": "standard_4",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "consul_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private",
          "static_ips": [
            "10.0.4.15"
          ]
        }
      ],
      "properties": {
        "consul": {
          "agent": {
            "mode": "server"
          }
        }
      }
    },
    {
      "name": "blobstore",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "persistent_disk_type": "standard_128",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "blobstore",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "route_registrar",
          "release": "cf"
        },
        {
          "name": "consul_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "consul": {
          "agent": {
            "services": {
              "blobstore": {}
            }
          }
        },
        "route_registrar": {
          "routes": [
            {
              "name": "blobstore",
              "port": 80,
              "registration_interval": "20s",
              "tags": {
                "component": "blobstore"
              },
              "uris": [
                "blobstore." + $config_settings.system_domain
              ]
            }
          ]
        }
      }
    },
    {
      "name": "postgres",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "persistent_disk_type": "standard_4",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "postgres",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private",
          "static_ips": [
            "10.0.4.11"
          ],
        }
      ],
      "update": {
        "serial": true
      }
    },
    {
      "name": "api",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "cloud_controller_ng",
          "release": "cf"
        },
        {
          "name": "cloud_controller_worker",
          "release": "cf"
        },
        {
          "name": "cloud_controller_clock",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "route_registrar",
          "release": "cf"
        },
        {
          "name": "consul_agent",
          "release": "cf"
        },
        {
          "name": "go-buildpack",
          "release": "cf"
        },
        {
          "name": "binary-buildpack",
          "release": "cf"
        },
        {
          "name": "nodejs-buildpack",
          "release": "cf"
        },
        {
          "name": "ruby-buildpack",
          "release": "cf"
        },
        {
          "name": "php-buildpack",
          "release": "cf"
        },
        {
          "name": "python-buildpack",
          "release": "cf"
        },
        {
          "name": "staticfile-buildpack",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "consul": {
          "agent": {
            "services": {
              "cloud_controller_ng": {}
            }
          }
        },
        "route_registrar": {
          "routes": [
            {
              "name": "api",
              "registration_interval": "20s",
              "port": 9022,
              "uris": [              
                "api." + $config_settings.system_domain
              ]
            }
          ]
        }
      }
    },
    {
      "name": "ha_proxy",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/haproxy"
      ],
      "jobs": [
        {
          "name": "haproxy",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "vip",
          "static_ips": [
            $cf_stack.HaProxyEip1Id
          ]
        },
        {
          "name": "public",
          "default": [
            "gateway",
            "dns"
          ]
        }
      ],
      "properties": {
        "ha_proxy": {
          "ssl_pem": ($config_haproxy_ssl_crt + "\n" + $config_haproxy_ssl_key)
        },
        "router": {
          "servers": [
            "10.0.4.12"
          ]
        }
      }
    },
    {
      "name": "hm9000",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "consul_agent",
          "release": "cf"
        },
        {
          "name": "hm9000",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "route_registrar",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "consul": {
          "agent": {
            "services": {
              "hm9000": {}
            }
          }
        },
        "route_registrar": {
          "routes": [
            {
              "name": "hm9000",
              "registration_interval": "20s",
              "port": 5155,
              "uris": [
                "hm9000." + $config_settings.system_domain
              ]
            }
          ]
        }
      }
    },
    {
      "name": "doppler",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "doppler",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "doppler": {
          "zone": "z1"
        },
        "doppler_endpoint": {
          "shared_secret": "PASSWORD"
        }
      }
    },
    {
      "name": "loggregator_trafficcontroller",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "loggregator_trafficcontroller",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "route_registrar",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "traffic_controller": {
          "zone": "z1"
        },
        "route_registrar": {
          "routes": [
            {
              "name": "doppler",
              "registration_interval": "20s",
              "port": 8081,
              "uris": [
                "doppler." + $config_settings.system_domain
              ]
            },
            {
              "name": "loggregator",
              "registration_interval": "20s",
              "port": 8080,
              "uris": [
                "loggregator." + $config_settings.system_domain
              ]
            }
          ]
        }
      }
    },
    {
      "name": "uaa",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "templates": [
        {
          "name": "uaa",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "route_registrar",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "login": {
          "catalina_opts": "-Xmx768m -XX:MaxPermSize=256m"
        },
        "route_registrar": {
          "routes": [
            {
              "name": "uaa",
              "registration_interval": "20s",
              "port": 8080,
              "uris": [
                "uaa." + $config_settings.system_domain,
                "*.uaa." + $config_settings.system_domain,
                "login." + $config_settings.system_domain,
                "*.login." + $config_settings.system_domain
              ]
            }
          ]
        },
        "uaa": {
          "admin": {
            "client_secret": "PASSWORD"
          },
          "batch": {
            "password": "PASSWORD",
            "username": "batch_user"
          },
          "cc": {
            "client_secret": "PASSWORD"
          },
          "scim": {
            "userids_enabled": true,
            "users": [
              "admin|PASSWORD|scim.write,scim.read,openid,cloud_controller.admin,doppler.firehose,routing.router_groups.read"
            ]
          }
        },
        "uaadb": {
          "address": "10.0.4.11",
          "databases": [
            {
              "name": "uaadb",
              "tag": "uaa"
            }
          ],
          "db_scheme": "postgresql",
          "port": 5524,
          "roles": [
            {
              "name": "uaaadmin",
              "password": "PASSWORD",
              "tag": "admin"
            }
          ]
        }
      }
    },
    {
      "name": "router",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "templates": [
        {
          "name": "gorouter",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        },
        {
          "name": "consul_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private",
          "static_ips": [
            "10.0.4.12"
          ]
        }
      ],
      "properties": {
        "dropsonde": {
          "enabled": true
        }
      }
    },
    {
      "name": "runner",
      "azs": [
        "a",
        "b"
      ],
      "instances": 1,
      "stemcell": "default",
      "vm_type": "t2_micro",
      "vm_extensions": [
        "cf/trusted-peer"
      ],
      "jobs": [
        {
          "name": "consul_agent",
          "release": "cf"
        },
        {
          "name": "dea_next",
          "release": "cf"
        },
        {
          "name": "dea_logging_agent",
          "release": "cf"
        },
        {
          "name": "metron_agent",
          "release": "cf"
        }
      ],
      "networks": [
        {
          "name": "private"
        }
      ],
      "properties": {
        "consul": {
          "agent": {
            "services": {
              "dea": {
                "check": {
                  "name": "dns_health_check",
                  "script": "/var/vcap/jobs/dea_next/bin/dns_health_check",
                  "interval": "5m",
                  "status": "passing"
                }
              }
            }
          }
        },
        "dea_next": {
          "zone": "z1"
        }
      }
    }
  ],
  "properties": {
    "networks": {
      "apps": "private"
    },
    "app_domains": [
      $config_settings.system_domain
    ],
    "cc": {
      "allow_app_ssh_access": false,
      "buildpacks": {
        "blobstore_type": "webdav",
        "webdav_config": {
          "password": "PASSWORD",
          "private_endpoint": "https://blobstore.service.cf.internal",
          "public_endpoint": ( "https://blobstore." + $config_settings.system_domain ),
          "secret": "PASSWORD",
          "username": "blobstore-username"
        }
      },
      "droplets": {
        "blobstore_type": "webdav",
        "webdav_config": {
          "password": "PASSWORD",
          "private_endpoint": "https://blobstore.service.cf.internal",
          "public_endpoint": ( "https://blobstore." + $config_settings.system_domain ),
          "secret": "PASSWORD",
          "username": "blobstore-username"
        }
      },
      "packages": {
        "blobstore_type": "webdav",
        "webdav_config": {
          "password": "PASSWORD",
          "private_endpoint": "https://blobstore.service.cf.internal",
          "public_endpoint": ( "https://blobstore." + $config_settings.system_domain ),
          "secret": "PASSWORD",
          "username": "blobstore-username"
        }
      },
      "resource_pool": {
        "blobstore_type": "webdav",
        "webdav_config": {
          "password": "PASSWORD",
          "private_endpoint": "https://blobstore.service.cf.internal",
          "public_endpoint": ( "https://blobstore." + $config_settings.system_domain ),
          "secret": "PASSWORD",
          "username": "blobstore-username"
        }
      },
      "bulk_api_password": "PASSWORD",
      "db_encryption_key": "PASSWORD",
      "default_running_security_groups": [
        "public_networks",
        "dns"
      ],
      "default_staging_security_groups": [
        "public_networks",
        "dns"
      ],
      "install_buildpacks": [
        {
          "name": "java_buildpack",
          "package": "buildpack_java"
        },
        {
          "name": "ruby_buildpack",
          "package": "ruby-buildpack"
        },
        {
          "name": "nodejs_buildpack",
          "package": "nodejs-buildpack"
        },
        {
          "name": "go_buildpack",
          "package": "go-buildpack"
        },
        {
          "name": "python_buildpack",
          "package": "python-buildpack"
        },
        {
          "name": "php_buildpack",
          "package": "php-buildpack"
        },
        {
          "name": "staticfile_buildpack",
          "package": "staticfile-buildpack"
        },
        {
          "name": "binary_buildpack",
          "package": "binary-buildpack"
        }
      ],
      "internal_api_password": "PASSWORD",
      "quota_definitions": {
        "default": {
          "memory_limit": 102400,
          "non_basic_services_allowed": true,
          "total_routes": 1000,
          "total_services": -1
        }
      },
      security_group_definitions: [
        {
          "name": "public_networks",
          "rules": [
            {
              "destination": "0.0.0.0-9.255.255.255",
              "protocol": "all"
            },
            {
              "destination": "11.0.0.0-169.253.255.255",
              "protocol": "all"
            },
            {
              "destination": "169.255.0.0-172.15.255.255",
              "protocol": "all"
            },
            {
              "destination": "172.32.0.0-192.167.255.255",
              "protocol": "all"
            },
            {
              "destination": "192.169.0.0-255.255.255.255",
              "protocol": "all"
            }
          ]
        },
        {
          "name": "dns",
          "rules": [
            {
              "destination": "0.0.0.0/0",
              "ports": "53",
              "protocol": "tcp"
            },
            {
              "destination": "0.0.0.0/0",
              "ports": "53",
              "protocol": "udp"
            }
          ]
        }
      ],
      "srv_api_uri": ( "https://api." + $config_settings.system_domain ),
      "staging_upload_password": "PASSWORD",
      "staging_upload_user": "staging_upload_user",
      "dea_use_https": false
    },
    "ccdb": {
      "address": "10.0.4.11",
      "databases": [
        {
          "name": "ccdb",
          "tag": "cc"
        }
      ],
      "db_scheme": "postgres",
      "port": 5524,
      "roles": [
        {
          "name": "ccadmin",
          "password": "PASSWORD",
          "tag": "admin"
        }
      ]
    },
    "consul": {
      "agent": {
        "log_level": null,
        "domain": "cf.internal",
        "servers": {
          "lan": [
            "10.0.4.15"
          ]
        }
      },
      "encrypt_keys": [
        "PASSWORD"
      ],
      "ca_cert": $config_consul_certs_server_ca_crt,
      server_cert: $config_consul_certs_server_crt,
      agent_cert: $config_consul_certs_agent_crt,
      server_key: $config_consul_certs_server_key,
      agent_key: $config_consul_certs_agent_key
    },
    "blobstore": {
      "admin_users": [
        {
          "password": "PASSWORD",
          "username": "blobstore-username"
        }
      ],
      "secure_link": {
        "secret": "PASSWORD"
      },
      "tls": {
        port: 443,
        cert: $config_blobstore_tls_crt,
        private_key: $config_blobstore_tls_key,
        ca_cert: $config_blobstore_ca_crt
      }
    },
    "databases": {
      "databases": [
        {
          "name": "ccdb",
          "tag": "cc",
          "citext": true
        },
        {
          "name": "uaadb",
          "tag": "uaa",
          "citext": true
        }
      ],
      "port": 5524,
      "roles": [
        {
          "name": "ccadmin",
          "password": "PASSWORD",
          "tag": "admin"
        },
        {
          "name": "uaaadmin",
          "password": "PASSWORD",
          "tag": "admin"
        }
      ]
    },
    "dea_next": {
      "advertise_interval_in_seconds": 5,
      "heartbeat_interval_in_seconds": 10,
      "memory_mb": 33996,
      "ca_cert": null,
      "client_cert": null,
      "client_key": null,
      "enable_ssl": false,
      "server_cert": null,
      "server_key": null
    },
    "description": "Cloud Foundry sponsored by Pivotal",
    "domain": $config_settings.system_domain,
    "etcd": {
      "machines": [
        "10.0.4.14"
      ],
      "peer_require_ssl": false,
      "require_ssl": false,
      "advertise_urls_dns_suffix": "etcd.service.cf.internal"
    },
    "hm9000": {
      "url": ( "https://hm9000." + $config_settings.system_domain ),
      "port": 5155,
      "ca_cert": $config_hm9000_ca_crt,
      "server_cert": $config_hm9000_server_crt,
      "server_key": $config_hm9000_server_key,
      "client_cert": $config_hm9000_client_crt,
      "client_key": $config_hm9000_client_key
    },
    "logger_endpoint": {
      "port": 4443
    },
    "loggregator": {
      "etcd": {
        "machines": [
          "10.0.4.14"
        ]
      }
    },
    "loggregator_endpoint": {
      "shared_secret": "PASSWORD"
    },
    "metron_agent": {
      "zone": "z1",
      "deployment": "minimal-aws",
      "dropsonde_incoming_port": 3457
    },
    "metron_endpoint": {
      "shared_secret": "PASSWORD"
    },
    "nats": {
      "machines": [
        "10.0.4.13"
      ],
      "password": "PASSWORD",
      "port": 4222,
      "user": "nats"
    },
    "ssl": {
      "skip_cert_verify": true
    },
    "system_domain": $config_settings.system_domain,
    "system_domain_organization": "default_organization",
    "uaa": {
      "clients": {
        "cf": {
          "access-token-validity": 600,
          "authorities": "uaa.none",
          "authorized-grant-types": "implicit,password,refresh_token",
          "autoapprove": true,
          "override": true,
          "refresh-token-validity": 2592000,
          "scope": "cloud_controller.read,cloud_controller.write,openid,password.write,cloud_controller.admin,scim.read,scim.write,doppler.firehose,uaa.user,routing.router_groups.read"
        },
        "cc-service-dashboards": {
          "authorities": "clients.read,clients.write,clients.admin",
          "authorized-grant-types": "client_credentials",
          "scope": "openid,cloud_controller_service_permissions.read",
          "secret": "PASSWORD"
        },
        "cloud_controller_username_lookup": {
          "authorities": "scim.userids",
          "authorized-grant-types": "client_credentials",
          "secret": "PASSWORD"
        },
        "cc_routing": {
          "authorities": "routing.router_groups.read",
          "secret": "PASSWORD",
          "authorized-grant-types": "client_credentials"
        },
        "gorouter": {
          "authorities": "routing.routes.read",
          "authorized-grant-types": "client_credentials,refresh_token",
          "secret": "PASSWORD"
        },
        "tcp_emitter": {
          "authorities": "routing.routes.write,routing.routes.read",
          "authorized-grant-types": "client_credentials,refresh_token",
          "secret": "PASSWORD"
        },
        "tcp_router": {
          "authorities": "routing.routes.read",
          "authorized-grant-types": "client_credentials,refresh_token",
          "secret": "PASSWORD"
        },
        "doppler": {
          "authorities": "uaa.resource",
          "secret": "PASSWORD"
        },
        "login": {
          "authorities": "oauth.login,scim.write,clients.read,notifications.write,critical_notifications.write,emails.write,scim.userids,password.write",
          "authorized-grant-types": "authorization_code,client_credentials,refresh_token",
          "redirect-uri": ( "https://login." + $config_settings.system_domain ),
          "scope": "openid,oauth.approvals",
          "secret": "PASSWORD"
        },
        "servicesmgmt": {
          "authorities": "uaa.resource,oauth.service,clients.read,clients.write,clients.secret",
          "authorized-grant-types": "authorization_code,client_credentials,password,implicit",
          "autoapprove": true,
          "redirect-uri": ( "https://servicesmgmt." + $config_settings.system_domain + "/auth/cloudfoundry/callback" ),
          "scope": "openid,cloud_controller.read,cloud_controller.write",
          "secret": "PASSWORD"
        }
      },
      "jwt": {
        signing_key: $config_uaa_jwt_private_pem,
        verification_key: $config_uaa_jwt_public_pem
      },
      "ssl": {
        "port": -1
      },
      "url": ( "https://uaa." + $config_settings.system_domain )
    }
  },
  "_version": "1"
}
