{
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for instances accessed via bastion or vpn.',
    GroupName: 'all',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [
      // Allow inbound traffic from VPN.
      {
        SourceSecurityGroupId: { Ref: 'SecurityGroupVpn' },
        FromPort: 0,
        ToPort: 0,
        IpProtocol: '-1',
      },
      // Allow inbound traffic from Bastion.
      {
        SourceSecurityGroupId: { Ref: 'SecurityGroupBastion' },
        FromPort: 0,
        ToPort: 0,
        IpProtocol: '-1',
      },
    ],
    SecurityGroupEgress: [
      // Allow outbound HTTP/HTTPS traffic.
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
