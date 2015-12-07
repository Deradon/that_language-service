shared_examples_for :empty_response do
  it "responds with empty JSON object" do
    expect(subject).to eq "{}"
  end
end
