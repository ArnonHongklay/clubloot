module V1
  class ContestsAPI < Grape::API
    extend Defaults::Engine

    resource :contests do
      get '/programs' do
        begin
          if programs = Program.all
            present :status, :success
          else
            present :status, :failure
          end
          present :status, :success
          present :data, programs, with: Entities::ProgramsExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :program_id, type: String, desc: "Program Id"
      end
      get '/templates' do
        begin
          if templates = Template.where(program: params[:program_id])
            present :status, :success
          else
            present :status, :failure
          end
          present :data, templates, with: Entities::TemplatesExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :template_id, type: String, desc: "Template Id"
      end
      get "/template" do
        begin
          if template = Template.find(params[:template_id])
            present :status, :success
          else
            present :status, :failure
          end
          present :data, template, with: Entities::TemplateExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :player, type: Integer, desc: "number of player"
      end
      get '/player' do
        begin
          fee = nil
          Contest.gem_matrix[:list].each{ |x| fee = x[:fee] if x[:player] == params[:player] }

          if fee.present?
            present :status, :success
          else
            present :status, :failure
          end
          present :data, fee
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
