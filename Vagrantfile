# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  ############################################################################
  ##  Could be any box, but I've added a 'dummy' to not waste time pulling 
  ##  legit box https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
  ##     $ vagrant box add dummy <URL>
  ############################################################################
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
  
    ##########################################################################
  	##  Supply the credentials for your AWS acount
  	##########################################################################  
    aws.access_key_id = "<ACCESS KEY ID>"
    aws.secret_access_key = "<SECRET ACCESS KEY>"
    aws.keypair_name = "<KEYPAIR FOR SSH TO INSTANCE>"


    ##########################################################################
    ##  This AMI is a AWS ubuntu box in us-east-1, feel free to replace with  
    ##  another Ubuntu AMI and change region, subnet, and security group
    ##  details, etc...
    ########################################################################## 
    aws.ami = "ami-f4cc1de2"
    aws.instance_type = "t2.micro"
    aws.region = "us-east-1"
    aws.subnet_id = "<SUBNET ID>"
    aws.security_groups = ['<VPC SECURITY GROUP']
    
    
    ##########################################################################
    ##  Leave these, they're needed for vagrant to be able to SSH and for
    ##  access to the http server on port 80 assuming the box isn't behind
    ##  ELB
    ########################################################################## 
    aws.associate_public_ip = true
	aws.ssh_host_attribute = :public_ip_address
	
	
    ##########################################################################	
	##  User you want and private key for ssh to your instances.  AWS sets the
	##  Ubuntu boxes to have a user 'ubuntu' only change this if you're using
	##  an AMI with another username.  The private key should work with the 
	##  aws.keypair_name set above.
	##########################################################################
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "<LOCAL PATH TO PRIVATE KEY>"
    
  end
  

  config.vm.provision "docker" do |d|
  
    ##########################################################################	
	##  This sets up and runs the redis server.  Shouldn't require any change
	##  as it uses the official redis container
	##########################################################################
	d.run "redis-server",
       image: "redis:3.2.8",
       args: "--net=host",
       cmd:  "redis-server"
	
	##########################################################################	
	##  This sets up and runs the guestbook app.  I'm using a guestbook image
	##  build and made publicly accessible at hub.docker.com (you're git 
	##  repo for guestbook is public so I figured it was fine).
	##  You'll specify The DATABASE_URL in the args string below
	##########################################################################
    d.run "guestbook",
       image: "raymondjplante12/guestbook:1.0.0",
       args: "-e DATABASE_URL=<DATABASE_URL> -e REDIS_HOST=127.0.0.1 --net=host",
   	   cmd: "bundle exec rackup -s Puma --port 80 --host 0.0.0.0"  
  end
end
