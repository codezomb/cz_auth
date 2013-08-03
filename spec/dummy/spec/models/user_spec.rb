require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

  context "class" do
    its(:class) { should respond_to(:requires_authentication) }
  end

  context "instance" do
    it { should respond_to(:authenticate) }
    it { should respond_to(:auth_token)   }
    it { should respond_to(:password)     }
    it { should respond_to(:email)        }

    its(:auth_token)            { should_not be_nil }
    its(:password_reset_token)  { should be_nil     }
  end

  #
  # Local Authentication
  #

  context "local authentication" do

    it "should return false if unable to authenticate" do
      subject.authenticate("notright").should be_false
    end

    it "should return an instance of the authenticated object when authenticating with a password" do
      subject.authenticate(subject.password).should eq subject
    end

    it "should return an instance of the authenticated object when authenticating with a token" do
      subject.authenticate(subject.auth_token).should eq subject
    end

  end

end