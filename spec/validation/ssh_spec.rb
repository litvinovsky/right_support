require 'spec_helper'

describe RightSupport::Validation::SSH do
  GOOD_PEM_PRIV_RSA           = read_fixture('good_priv_rsa.pem')
  GOOD_ENCRYPTED_PEM_PRIV_RSA = read_fixture('encrypted_priv_rsa.pem')
  GOOD_SSH_PUB_RSA            = read_fixture('good_pub_rsa.ssh')
  GOOD_SSH_PUB_DSA            = read_fixture('good_pub_dsa.ssh')
  GOOD_PEM_PRIV_DSA           = read_fixture('good_priv_dsa.pem')

  context :ssh_private_key? do
    it 'recognizes valid keys' do
      RightSupport::Validation.ssh_private_key?(GOOD_PEM_PRIV_RSA).should == true
      RightSupport::Validation.ssh_private_key?(GOOD_PEM_PRIV_DSA).should == true
    end
    it 'considers encrypted keys to be "bad" (not usable)' do
      RightSupport::Validation.ssh_private_key?(GOOD_ENCRYPTED_PEM_PRIV_RSA).should == false
    end
    it 'recognizes bad keys' do
      RightSupport::Validation.ssh_private_key?(corrupt(GOOD_PEM_PRIV_RSA)).should == false
      RightSupport::Validation.ssh_private_key?(corrupt(GOOD_PEM_PRIV_RSA, 16)).should == false
      RightSupport::Validation.ssh_private_key?(nil).should == false
      RightSupport::Validation.ssh_private_key?('').should == false
    end
  end

  context :ssh_public_key? do
    it 'recognizes valid keys' do
      RightSupport::Validation.ssh_public_key?(GOOD_SSH_PUB_RSA).should == true
    end
    it 'recognizes bad keys' do
      RightSupport::Validation.ssh_public_key?('ssh-rsa AAAAB3Nhowdybob').should == false
      RightSupport::Validation.ssh_public_key?('ssh-rsa hello there').should == false
      RightSupport::Validation.ssh_public_key?('ssh-rsa one two three! user@host').should == false
      RightSupport::Validation.ssh_public_key?('fafafafafafa mumumumumumu').should == false
      RightSupport::Validation.ssh_public_key?(nil).should == false
      RightSupport::Validation.ssh_public_key?('').should == false
    end
  end
end