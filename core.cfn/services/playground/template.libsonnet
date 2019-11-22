local amazonLinux = 'ami-0ff8a91507f77f867';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Internal Instance Template',
  Parameters: {

    Namespace: {
      Description: 'A unique name to associate with resources for tagging purposes.',
      Type: 'String',
    },

    PlaygroundSecurityGroupId: {
      Description: 'Security group to attach to instance.',
      Type: 'String',
    },
    ElbSecurityGroupId: {
      Description: 'Security group to attach to instance.',
      Type: 'String',
    },

    SubnetId: {
      Description: 'ID of the subnet to place the instance in.',
      Type: 'String',
    },

    ZoneId: {
      Description: 'Route53 zone to add the service DNS records to.',
      Type: 'String',
    },

    DnsName: {
      Description: 'FQDN to use for the service',
      Type: 'String',
    },
  },

  Resources: {
    DnsRecord: {
      Type: 'AWS::Route53::RecordSet',
      Properties: {
        HostedZoneId: { Ref: 'ZoneId' },
        Name: { Ref: 'DnsName' },
        TTL: '300',
        Type: 'CNAME',
        ResourceRecords: [{ 'Fn::GetAtt': ['LoadBalancer', 'DNSName'] }],
      },
    },

    LaunchConfiguration: {
      Type: 'AWS::AutoScaling::LaunchConfiguration',
      Properties: {
        ImageId: amazonLinux,
        KeyName: 'akerr-lab-key',
        InstanceType: 't3.micro',
        SecurityGroups: [{ Ref: 'PlaygroundSecurityGroupId' }],
        UserData: '',
      },
    },

    AutoScalingGroup: {
      Type: 'AWS::AutoScaling::AutoScalingGroup',
      Properties: {
        AutoScalingGroupName: { 'Fn::Sub': '${Namespace}-asg-playground' },
        LaunchConfigurationName: { Ref: 'LaunchConfiguration' },
        LoadBalancerNames: [{ Ref: 'LoadBalancer' }],
        VPCZoneIdentifier: [{ Ref: 'SubnetId' }],
        MinSize: '1',
        MaxSize: '1',
        Tags: [{
          Key: 'Name',
          Value: { 'Fn::Sub': '${Namespace}-asg-playground' },
          PropagateAtLaunch: true,
        }],
      },
    },

    LoadBalancer: {
      Type: 'AWS::ElasticLoadBalancing::LoadBalancer',
      Properties: {
        Scheme: 'internal',
        Subnets: [{ Ref: 'SubnetId' }],
        SecurityGroups: [{ Ref: 'ElbSecurityGroupId' }],
        Listeners: [{
          LoadBalancerPort: '22',
          Protocol: 'TCP',
          InstancePort: '22',
          InstanceProtocol: 'TCP',
        }],
        HealthCheck: {
          HealthyThreshold: '2',
          Interval: '15',
          Target: 'TCP:22',
          Timeout: '10',
          UnhealthyThreshold: '2',
        },
      },
    },

  },
}
