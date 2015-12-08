shared_examples_for :empty_response do
  it "responds with empty JSON object" do
    expect(body).to eq "{}"
  end
end
