# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  respond_to :html, :turbo_stream
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in) if resource.persisted?
    sign_in(resource_name, resource)

    respond_to do |format|
      format.turbo_stream {
        # Customize this part to call your `recede_or_redirect_to` method
        recede_or_redirect_to after_sign_in_path_for(resource)
      }
      format.html { redirect_to after_sign_in_path_for(resource) }
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
