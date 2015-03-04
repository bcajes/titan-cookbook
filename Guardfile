scope group: :unit

group :unit do
  guard :rubocop do
    watch(/.+\.rb$/)
    watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
  end

  guard :rspec, cmd: 'chef exec rspec --fail-fast', all_on_start: false do
    watch(/{^libraries\/(.+)\.rb$/)
    watch(/^spec\/(.+)_spec\.rb$/) { 'spec' }
    watch(/^(attributes)\/(.+)\.rb$/)   { 'spec' }
    watch(/^(recipes)\/(.+)\.rb$/)   { 'spec' }
    watch(/^recipes\/common\.rb$/)   { 'spec' }
    watch('spec/spec_helper.rb')      { 'spec' }
    watch(/^(.+)erb$/) { 'spec' }
  end
end
