#!/usr/bin/python
import boto3
import sys
import os
Stack_Name = "MediaWiki-CICD-Pipeline-instance"

def update_hosts(Stack_Name):
    client = boto3.client('cloudformation', region_name='us-east-1')
    ec2 = boto3.resource('ec2', region_name='us-east-1')
    stack_resources = client.list_stack_resources(StackName=Stack_Name)
    # network_interface_association = ec2.NetworkInterfaceAssociation(resource['PhysicalResourceId'])
    hosts = open(os.path.dirname(__file__) + '/../hosts',"w")
    hosts.write('[instance]')
    for resource in stack_resources['StackResourceSummaries']:
        if resource['ResourceType'] == 'AWS::CloudFormation::Stack':
            update_hosts(resource['PhysicalResourceId'].split('/')[1])
        elif resource['ResourceType'] == 'AWS::EC2::Instance' and resource['ResourceStatus'] == 'CREATE_COMPLETE':
            instance = ec2.Instance(resource['PhysicalResourceId'])
            print resource['PhysicalResourceId']
            print instance.public_dns_name
            hosts.write('\n')
            hosts.write(instance.public_ip_address)
    hosts.close()


update_hosts(Stack_Name)




