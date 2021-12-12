class UsersController < ApplicationController
before_action :validate_email_update, only: :update

    private
    def validate_email_update
    @new_email = params[:email].to_s.downcase

    # Ketika Kolom E-Mail tidak diisi
    if @new_email.blank?
    return render json: { status: 'Kolom E-Mail tidak boleh kosong.' }, status: :bad_request
    end
    ##########################################################

    # Ketika E-Mail baru dan E-Mail lama sama
    if  @new_email == current_user.email
    return render json: { status: 'Current Email and New email cannot be the same' }, status: :bad_request
    end
    ##########################################################

    # Ketika E-Mail baru dan E-Mail lama sama
    if User.email_used?(@new_email)
    return render json: { error: 'E-Mail ini sudah digunakan.'] }, status: :unprocessable_entity
    end
    end
    ##########################################################
  
    # Ketika Pesan Konfirmasi telah dikirim ke alamat E-Mail baru
    def update
        if current_user.update_new_email!(@new_email)
          # SEND EMAIL HERE
          render json: { status: 'Pesan Konfirmasi telah dikirim ke alamat E-Mail baru Anda.' }, status: :ok
        else
          render json: { errors: current_user.errors.values.flatten.compact }, status: :bad_request
        end
    end

    # Ketika Link E-Mail tidak cocok atau sudah kedaluarsa
    def email_update
        token = params[:token].to_s
        user = User.find_by(confirmation_token: token)
      
        if !user || !user.confirmation_token_valid?
          render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: :not_found
        else
          user.update_new_email!
          render json: {status: 'Email updated successfully'}, status: :ok
        end
    end
    ##########################################################

end