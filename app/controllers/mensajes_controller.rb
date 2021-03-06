class MensajesController < ApplicationController

  before_action :comprobar

  def index # GET
    mensajes = Mensaje.all
    render json: mensajes
  end

  def show # GET
    mensaje = Mensaje.find_by(id: params['id'])
    render json: mensaje
  end

  def create # POST
    @remitente = params[:id]
    @emisor = @remitente
    @destinatario = params[:destinatario]
    @contenido = params[:contenido]

    usuario = Usuario.find_by(nickname: params['nickname'])
    
    @mensaje = Mensaje.create(:contenido => @contenido, :remitente_id => Usuario.find(@remitente).id, :destinatario_id => Usuario.find(@destinatario).id)
    
    if @mensaje.save 
      @fecha = @mensaje.created_at.to_s
      p "-------------antes!-------------"
      p @fecha
      p "-------------antes!-------------"
      sendNodeMsj(@emisor, @destinatario, @contenido, @fecha)
      # mensaje = usuario.mensajes.new(contenido: params['contenido']);
      # mensaje = Mensaje.create(destinatario_id: usuario.id, contenido: params['contenido'], remitente_id: 1)
      # mensaje.save
      # mensaje.errors.full_messages
      render :json=>{:success=>true},:status=>201
    else
      render :json=>{:success=>false},:status=>422
    end
  
  end

  def chat
    # @remitente = params[:remitente]
    @remitente = params[:id]
    @destinatario = params[:destinatario]

    @chat = Mensaje.where('destinatario_id' => @destinatario).where('remitente_id' => @remitente).or(Mensaje.where('destinatario_id' => @remitente).where('remitente_id' => @destinatario)).order(created_at: :asc)#.select(:id, :contenido, :created_at )

    if(@chat)
      render :json=>{:success=>true, :resultado=>@chat},:status=>200
    else
      render :json=>{:success=>false, :resultado=>"Hubo un problema"},:status=>404
    end
      
  end

  private

  def comprobar
  if(!params.has_key?(:authentication_token))
    render :json=>{:success=>false, :message=>"falta parametro authentication_token"}, :status=>422
  else
    @user = Usuario.find_by_authentication_token(params[:authentication_token])
      if(!@user)
        render :json=>{:success=>false, :message=>"token mal"}, :status=>422
      # elsif (@user.authentication_token != Usuario.find(params[:remitente]).authentication_token)
      elsif (@user.authentication_token != Usuario.find(params[:id]).authentication_token)
        render :json=>{:success=>false, :message=>"token mal"}, :status=>422
      end
      if(@user)
        return true
      end
    end
  end

  def sendNodeMsj(remitente, destinatario, contenido, fecha)
    @emisor = remitente
    @receptor = destinatario
    @mensaje = contenido
    @fecha = fecha 

    p "----------------------send----------------------"
    p params
    p fecha
    p "----------------------send----------------------"
    # Al servidor de Node en Heroku
    # response = HTTParty.get('https://redtipsocket.herokuapp.com/mensaje?emisor='+remitente+'&mensaje='+@mensaje+'&receptor='+@receptor+'', :verify => false)
    # ##################################
    # Al servidor de Node en localhost.
    # response = HTTParty.get('https://redtipsocket.herokuapp.com/mensaje?emisor='+remitente+'&mensaje='+@mensaje+'&receptor='+@receptor+'&created_at='+@fecha+'', :verify => false)
    response = HTTParty.get('http://192.168.10.153:8080/mensaje?emisor='+remitente+'&mensaje='+@mensaje+'&receptor='+@receptor+'&created_at='+@fecha+'', :verify => false)
    # ##################################
  end

end
