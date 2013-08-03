class User < ActiveRecord::Base
	requires_authentication remote_auth_url: 'http://localhost:3000/users/authentication'
end
