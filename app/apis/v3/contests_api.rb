module V3
  class ContestsAPI < Grape::API

    resource :templates do
      get '/' do
        begin
          present :status, :success
          present :data, Template.show, with: Entities::V3::TemplatesExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end

    resource :quiz do
      params do
        requires :template_id,  type: String, desc: "Template Id"
      end
      get '/' do
        begin
          present :status, :success
          present :data, Template.find(params[:template_id]).questions, with: Entities::V3::QuestionsExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end

    resource :contest do
      params do
        requires :token, type: String, default: nil, desc: 'User Token'
        requires :template_id, type: String, desc: "Template Id"
        requires :details, type: Hash do
          requires :name, type: String
          requires :player, type: Integer
          requires :fee, type: Integer
        end
        requires :quizes, type: Array[JSON], default: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]', desc: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]'
      end
      post "/new" do
        begin
          template = Template.find(params[:template_id])
          template.new_contest(current_user, params[:details], params[:quizes])

          present :status, :success
          present :data, [] #, with: Entities::V2::ContestExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :token, type: String, default: nil, desc: 'User Token'
        requires :contest_id, type: String, desc: 'contest_id'
        requires :quizes, type: Array[JSON], default: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]', desc: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]'
      end
      post "/join" do
        begin
          contest = Contest.find(params[:contest_id])
          result = current_user.join_contest(contest, params[:quizes])

          present :status, :success
          present :data, [] #, with: Entities::V2::ContestExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
