{
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for VPN instances.',
    GroupName: 'vpn',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [
      // Allow SSH inbound traffic.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
      // Allow inbound UDP traffic on port 1194.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 1194,
        ToPort: 1194,
        IpProtocol: 'udp',
      },
      // Allow inbound TCP traffic on port 943.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 943,
        ToPort: 943,
        IpProtocol: 'tcp',
      },
      // Allow inbound HTTPS traffic on port.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 443,
        ToPort: 443,
        IpProtocol: 'tcp',
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
