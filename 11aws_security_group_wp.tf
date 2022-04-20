resource "aws_security_group" "demovpcwebSG" {
  #for ease of use typically for anything other than a public webpage we don't want our access to be open to the world but for this example we will not change anything
  name        = "webSG" #take note of the sg here this will be for the website that will sit on our ec2 instance
  description = "Allows TCP,ICMP-IPv4,HTTP,SSH to the web EC2 instance"
  vpc_id      = data.aws_vpc.demo_vpc.id #again here refering to file 01

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.demo_vpc.cidr_block]
  }

  ingress {
    description = "ICMP from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] #for proper security we will input our private ip address for this cidr range /32
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.demo_vpc.cidr_block]
  }

  egress {
    #here we are allowing everything outbound to the public internet
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_vpc_WebSG"
  }

  depends_on = [
    #check file 10 for dependency
    aws_route_table_association.assoc1
  ]
}
