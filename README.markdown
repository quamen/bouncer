Bouncer
=======

Your rails app is like a club. Everyone wants in. Most users are fine, but every now and again someone wants to cause trouble.

You need a bouncer to keep the riff raff out.

Bouncer allows you to filter the params passed into your controller so that you can safely manage mass assignment at the controller level.


Example
=======

Take a user model with the following attributes: login, password, admin.

admin is a boolean that signifies whether the user has the ability to perform admin tasks.

You probably use the following code throughout your application in controllers. 

<pre>
<code>
  @user = User.new(params[:user])
</code>
</pre>

This code is problematic. Should a user decide to fiddle with your parameters and pass in admin=true you could have a bit of a problem on your hands.

You need a bouncer with a door list.

<pre>
<code>
class UsersController < ApplicationController
  allow_assignment :user => [ :login, :password ]
end
</code>
</pre>

Now you can safely use <code> User.new(params[:user])</code> in your controller to mass assign only the attributes you've said are safe.

You should use allow_assignment in every controller within your application. By default bouncer will strip everything from the params hash that isn't required by rails to operate.

Why Not Use attr_accessible?
==========================

attr_accessible is great. But it's handled at the model level.

You might want to allow assignment of the admin attribute from an admin specific user interface.

You end up with code like this:

<pre>
<code>
class AdminUsersController < ApplicationController

  ...
  @user = User.new(params[:user])
  @user.admin = params[:user][:admin]
  ...
  
end
</code>
</pre>

The following is much nicer:

<pre>
<code>
class UsersController < ApplicationController
  allow_assignment :user => [ :login, :password ]
end

class AdminUsersController < ApplicationController
  allow_assignment :user => [ :login, :password, :admin ]
end
</code>
</pre>

Copyright (c) 2009 Gareth Townsend, released under the MIT license

Thanks to Josh Bassett for helping nut out <code>self.request.env['rack.routing_args'].keys</code> and other refactorings.
