CzAuth
=

Simple authentication functionality packaged into  gem

Usage
=

```shell
rails g cz_auth:install
rails g cz_auth:model <model_name>
rake db:migrate
```

You can also work with existing models, by adding the following to an existing model
```ruby
requires_authentication
```

Details
=

The generator will generate a model with the following attributes:

* email
* password_digest
* auth_token
* password_reset_token

It will then place a `requires_authentication` method at the top of the model. This will trigger `has_secure_password`, and before filter used to generate an auth_token.

The model will gain the following methods, and can be override at will:

__generate_token__: This method takes one argument, which is the column that the token will be placed in. By default, this can be `auth_token`, or `password_reset_token`

It does not create controllers, or mailers. These are left to the main application to implement.
