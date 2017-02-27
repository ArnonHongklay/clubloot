module V1
  class UsersAPI < Grape::API
    extend Defaults::Engine

    helpers do
      params :token do
        optional :token, type: String, default: nil
      end
      params :attributes do
        optional :attributes, type: Hash, default: {}
      end
    end

    resource :users do
      params do
        # requires :name,    type: String, desc: "email of the user"
        # requires :program, type: String, desc: "password of the user"
        # requires :number_question,  type: Integer, desc: "email of the user"
        # requires :number, type: Integer, desc: "password of the user"
        requires :token,        type: String, default: nil, desc: 'User Token'
        requires :template_id,  type: String, desc: "Template Id"
        # requires :attributes, type: Hash, default: {}
      end
      post "/contest/new" do
        begin
          template = Template.find(params[:template_id])

          if user = User.find_by(token: params[:token])
            if contest = Contest.create_contest(user, template)
              present :status, :success
              present :data, contest #, with: Entities::AuthExpose
            else
              present :status, :failure
              present :data, "Can't creating a new contest."
            end
          else
            present :status, :failure
            present :data, "Users don't have in our system."
          end
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :token, type: String, default: nil, desc: 'User Token'
        requires :contest_id, type: String, desc: 'contest_id'
      end
      post "/contest/join" do
        begin
          if user = User.find_by(token: params[:token])
            if user.join_contest(params[:contest_id])
              present :status, :success
              present :data, contest #, with: Entities::AuthExpose
            else
              present :status, :failure
              present :data, "Can't join a contest."
            end
          else
            present :status, :failure
            present :data, "Users don't have in our system."
          end
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
