class PasswordsController < ApplicationController

    # Ketika E-Mail tidak tersedia
    def forgot
        if params[:email].blank?
          return render json: {error: 'E-Mail Tidak tersedia'}
        end
    
        user = User.find_by(email: email.downcase)
    ##########################################################
    
    # Ketika E-Mail tidak ditemukan / salah mengisi
        if user.present? && user.confirmed_at?
          user.generate_password_token!
          # SEND EMAIL HERE
          render json: {status: 'ok'}, status: :ok
        else
          render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
        end
      end
    ##########################################################

    # Ketika Token tidak tersedia, jalankan tugas def reset
      def reset
        token = params[:token].to_s
    
        if params[:email].blank?
          return render json: {error: 'Token tidak tersedia'}
        end
    
        user = User.find_by(reset_password_token: token)
    ##########################################################

    # Ketika Link Sudah Kedaluarsa
        if user.present? && user.password_token_valid?
          if user.reset_password!(params[:password])
            render json: {status: 'ok'}, status: :ok
          else
            render json: {error: user.errors.full_messages}, status: :unprocessable_entity
          end
        else
          render json: {error:  ['Link tidak cocok atau sudah Kedaluarsa. Coba buat link baru.']}, status: :not_found
        end
      end
    ##########################################################

    # Ketika Password Tidak Tersedia
    def update
        if !params[:password].present?
          render json: {error: 'Password tidak tersedia'}, status: :unprocessable_entity
          return
        end
        if current_user.reset_password(params[:password])
            render json: {status: 'ok'}, status: :ok
          else
            render json: {errors: current_user.errors.full_messages}, status: :unprocessable_entity
          end
        end
    ##########################################################
end