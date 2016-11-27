require 'prmd/rake_tasks/combine'
require 'prmd/rake_tasks/verify'
require 'prmd/rake_tasks/doc'

namespace :schema do
  Prmd::RakeTasks::Combine.new do |t|
    t.options[:meta] = 'docs/schema/meta.json'
    t.paths << 'docs/schema/schemata'
    t.output_file = 'docs/schema/api.json'
  end

  Prmd::RakeTasks::Verify.new do |t|
    t.files << 'docs/schema/api.json'
  end

  Prmd::RakeTasks::Doc.new do |t|
    t.files = { 'docs/schema/api.json' => 'docs/schema/api.md' }
  end
end

task default: ['schema:combine', 'schema:verify', 'schema:doc']
