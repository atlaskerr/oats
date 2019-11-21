{
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for SSH bastion instances.',
    GroupName: 'bastion',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [
      // Allow SSH inbound traffic.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    ],
    SecurityGroupEgress: [
      // Allow outbound traffic to entire VPC.
      {
        CidrIp: '10.55.0.0/16',
        FromPort: 0,
        ToPort: 0,
        IpProtocol: '-1',
      },
      // Allow outbound HTTP/S traffic to everywhere for updates and whatnot.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 80,
        ToPort: 80,
        IpProtocol: 'tcp',
      },
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 443,
        ToPort: 443,
        IpProtocol: 'tcp',
      },
    ],
  },
}
