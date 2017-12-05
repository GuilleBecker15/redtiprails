class Usuarios::RegistrationsController < Devise::RegistrationsController
  
  respond_to :json
  

  def create
    params.delete :registration
    params.delete :type
    p "------------ ----------------------"
    # res = as_json(params[:data])
    # p res 
    
    p "----------------------------------"
    usuario = Usuario.new(usuario_params[:attributes])
    # usuario.skip_confirmation_notification!
    
    if usuario.save
      puts usuario.attributes
      # render :json => usuario.as_json(:auth_token => usuario.authentication_token,:email => usuario.email), :status => 201
      
      #Renderizo esto cuando este pronto el envio de mail
      # render :json =>{:success=>true, :message=>"El usuario se ha creado satisfactoriamente, se ha enviado un mail de confirmacion a su cuenta de correo electronico"}, :status=>201

      #Mientras tanto renderizo esto
      # render :json =>{:success=>true, :_id=>usuario.id, :email=>usuario.email, :confirmation_token=>usuario.confirmation_token}, :status=>201
      # render :json =>{:data=>{:id=>usuario.id, :attributes=>{:nickname=>usuario.nickname, :facebook=>usuario.facebook, :instagram=>usuario.instagram, :linkedin=>usuario.linkedin, :twitter=>usuario.twitter, :avatar=>usuario.avatar, :authentication_token=>usuario.authentication_token, :email=>usuario.email}, :type=>"usuario"}}
      render json: usuario
      return
    
    else
      # warden.custom_failure!
      render :json =>{:success=>false, :message=>"repetido"}, :status=>422
      # render :json => usuario.errors, :status => 422
    
    end
  
  end

   def destroy

    resource = Usuario.find_for_database_authentication(:email => params[:user_credentials][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user_credentials][:password])


      @usuario = Usuario.find_by_id(params["id"])
      p "-------------------------"
      p params
      p "-------------------------"
      p Usuario.find_by_id(params["id"])
      p "-------------------------"
      p @usuario
      p "-------------------------"
      @usuario.destroy
      render :json=> {:success=>true, :message=>"Usuario eliminado correctamente"}, :status=>200
      # respond_to do |format|
        # format.html { redirect_to usuarios_url, notice: 'Usuario was successfully destroyed.' }
        # format.json { head :no_content }
      # end
      end
    invalid_login_attempt
  end

  private

  def usuario_params
    
    # params.require(:data).permit(:nickname, :password, :email, :facebook, :twitter, :linkedin, :instagram, :avatar, :type, :attributes )
    # params.require(:data).permit(:type, :attributes )
    params.require(:data).permit(:type, attributes:[ :avatar, :email, :facebook, :instagram, :linkedin, :nickname, :password, :'authentication-token', :twitter] )
    # params.permit(:nickname, :password, :email, :facebook, :twitter, :linkedin, :avatar, :registration)
  end

  protected

  def book_params
    res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:usuario])
    res[:publisher_type] = res[:publisher_type].singularize.capitalize
    res
  end


  def invalid_login_attempt
    # warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end

  ############################################################################## 

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
