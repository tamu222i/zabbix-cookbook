# zabbix-cookbook

Chef cookbook for Zabbix.
Use offical Zabbix packages & minimal other packages.
Version 2.2.
https://www.zabbix.com/documentation/2.2/manual/installation/install_from_packages

## Supported Platforms

CentOS6.x

## Requirement

Chef Development Kit Version: 0.1.0

## Usage

### Use Bershelf

Add Berksfile:

```
cookbook 'zabbix', :git => 'https://github.com/tamu222i/zabbix-cookbook.git'
```

Include `zabbix-cookbook` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[zabbix]"
  ]
}
```

and cook.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

The MIT License (MIT)

Copyright (c) 2014 tamu222i
