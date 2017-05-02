module V3
  class ContestsAPI < Grape::API

    resource :contest do
      params do
        requires :token,      type: String, default: nil, desc: 'User Token'
      end
      get ":contest_id" do
        begin
          if current_user
            if contest = current_user.contests.find(params[:contest_id])
              present :status, :success
              present :data, contest, with: Entities::V2::ContestAllExpose
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
        requires :token,        type: String, default: nil, desc: 'User Token'
        requires :template_id,  type: String, desc: "Template Id"
        requires :details, type: Hash do
          requires :name, type: String
          requires :player, type: Integer
          requires :fee, type: Integer
        end
      end
      post "/new" do
        begin
          template = Template.find(params[:template_id])

          if current_user
            if contest = Contest.create_contest(current_user, template, params[:details])
              present :status, :success
              present :data, contest, with: Entities::V2::ContestExpose
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
      post "/join" do
        begin
          if current_user
            if contest = Contest.join_contest(current_user, params[:contest_id])
              present :status, :success
              present :data, contest, with: Entities::V2::ContestExpose
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

      params do
        requires :token, type: String, default: nil, desc: 'User Token'
        requires :contest_id, type: String, desc: 'contest_id'
      end
      post "/edit" do
        begin
          if current_user
            if contest = Contest.edit_contest(current_user, params[:contest_id])
              present :status, :success
              present :data, contest, with: Entities::V2::ContestEditExpose
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

      params do
        requires :token,        type: String, default: 'EJGB2R9ETPHNJSHGDYSJ283KTXCBSR6X', desc: 'User Token'
        requires :contest_id,   type: String, default: '58b82e942cc3c43e4e31ca2c', desc: "Contest Id"
        requires :details,      type: Array[JSON], default: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]', desc: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]'
      end
      post "/quiz" do
        begin
          if current_user
            if contest = current_user.contests.find(params[:contest_id])
              if quiz_contest = Contest.quiz(current_user, contest, params[:details])
                present :status, :success
                present :data, quiz_contest #, with: Entities::V2::AuthExpose
              else
                present :status, :failure
                present :data, "Can't complete quiz"
              end
            else
              present :status, :failure
              present :data, "Can't found contest"
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
        requires :token,        type: String, default: 'EJGB2R9ETPHNJSHGDYSJ283KTXCBSR6X', desc: 'User Token'
        requires :contest_id,   type: String, default: '58b82e942cc3c43e4e31ca2c', desc: "Contest Id"
        requires :details,      type: Array[JSON], default: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]', desc: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]'
      end
      post "/edit_quiz" do
        begin
          if current_user
            if contest = current_user.contests.find(params[:contest_id])
              if quiz_contest = Contest.edit_quiz(current_user, contest, params[:details])
                present :status, :success
                present :data, quiz_contest #, with: Entities::V2::AuthExpose
              else
                present :status, :failure
                present :data, "Can't complete quiz"
              end
            else
              present :status, :failure
              present :data, "Can't found contest"
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