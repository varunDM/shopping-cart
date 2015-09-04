#
# Devise sign in related activities
#
# @author [qbuser]
#
class SessionsController < Devise::SessionsController
  layout 'devise'  # Assign a new layout for devise sign in page
end
