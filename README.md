# cf_wordpress

Description
===========
Cloudformation Template and Chef Recipe to spin-up and new VPC and Web instance within AWS

Requirements
============

Platform
--------

* Latest Amazon Linux AMI


Usage
=====

Store the "wordpress.rb" file in a AWS s3 bucket, or other http/s accessible location. You will then need to update the source for the "wordpress_recipe.rb" under the "run_chef" configSet.

Load the "VPC_Single_Wordpress_instance.cf.json" into AWS's Cloudformation, and set the parameters.

* Stackname - Name of the Cloudformation Stack you are creating. (default: nil, Required)
* DBName - The WordPress database name. (default: wordpressdb, Required)	
* DBPassword - The WordPress database admin account password. (default: nil, Required)
* DBRootPassword - The WordPress database root account password. (default: nil, Required)
* DBUser - The WordPress database admin account username. (default: nil, Required)
* InstanceType - WebServer EC2 instance type. (default: t2.small, Required)
* KeyName - Name of an existing EC2 KeyPair to enable SSH access to the instance. (default: nil, Required)
* SSHLocation - The IP address range that can be used to SSH to the EC2 instances. (default: 0.0.0.0/0, Required)


License and Author
==================

* Author:: David Lundy (Dvaid.R.Lundy@gmail.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
