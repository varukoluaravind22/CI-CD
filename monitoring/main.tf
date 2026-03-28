resource "aws_instance" "observability" {
    ami           = "ami-07216ac99dc46a187"
    instance_type = "t2.large"
    security_groups = [ aws_security_group.Monitoring-sec-group]
    key_name = "devops"
    user_data = templatefile("./install.sh",{})
    tags ={
        name= "Monitoring-server"
    }
    root_block_device {
      volume_size = 30
    }
}
resource "aws_security_group" "Monitoring-sec-group" {
    name= "Monitoring-sec-group"
    description = "Allowed inbound traffice"

    ingress = [ 
        for port in [22,80,443,9100,9090,3000,]:{
            description      = "inbound rules"
            from_port        = port
            to_port          = port
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            security_groups  = []
            self             = false
        }
     ]

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
      "name" = "Monitoring-sec-group"
    }
}

