aws ec2 run-instances --image-id ami-0fe8bec493a81c7da \
--count 1 --instance-type t3.micro \
 --key-name Admin57_Stockholm \
--security-group-ids sg-0ff94e564f13522ea \
--subnet-id subnet-03a9308eb4fd46c05
