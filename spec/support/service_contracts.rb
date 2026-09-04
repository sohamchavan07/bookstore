# frozen_string_literal: true

RSpec.shared_examples 'service object contract' do
  it 'responds to success?/failure?' do
    expect(subject).to respond_to(:success?)
    expect(subject).to respond_to(:failure?)
  end
end

RSpec.shared_examples 'service failure contract' do
  it 'provides an error message on failure' do
    expect(subject.failure?).to be true
    expect(subject.error).to be_present
  end
end
