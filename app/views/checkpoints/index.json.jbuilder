json.array!(@checkpoints) do |checkpoint|
  json.extract! checkpoint, :id, :CheckpointID, :GridReference, :CheckpointDescription
  json.url checkpoint_url(checkpoint, format: :json)
end
