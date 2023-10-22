aws ec2 run-instances --image-id ami-0fe8bec493a81c7da \
--count 1 --instance-type t3.large \
 --key-name demo-1 \
--security-group-ids sg-0e319542dd620aefa \
--subnet-id subnet-061556b319868f4ec

