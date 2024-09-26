# frozen_string_literal: true

namespace :deploy do
  namespace :check do
    before :linked_files, :set_linked_files_remote do
      on roles(:app), in: :sequence, wait: 10 do
        fetch(:linked_files).each do |file|
          unless test("[ -f #{shared_path}/#{file} ]")
            upload!(file, "#{shared_path}/#{file}")
          end
        end
      end
    end
  end
end
