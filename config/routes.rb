Centraal::Application.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create'
  
  match "/dispatchers/receive_call" => "dispatchers#receive_call", as: :receive_call
  match "/dispatchers/conclude_call" => "dispatchers#conclude_call", as: :conclude_call
  match "/dispatchers/receive_voicemail" => "dispatchers#receive_voicemail", as: :receive_voicemail
  match "/dispatchers/receive_voicemail_transcription" => "dispatchers#receive_voicemail_transcription", as: :receive_voicemail_transcription, via: :post
  match "/dispatchers/process_owner_gather" => "dispatchers#process_owner_gather", as: :process_owner_gather, via: :post
  match "/dispatchers/receive_voicemail_greeting" => "dispatchers#receive_voicemail_greeting", as: :receive_voicemail_greeting, via: :post

  match "/voicemails/:id/play" => "voicemails#play", as: "play_voicemail"
  match "/voicemails/:id/mark_as_read" => "voicemails#mark_as_read", as: "mark_voicemail_as_read", via: :post

  match "/client_ping/:id" => "twilio_clients#ping", as: "client_ping", via: :post

  match "/phone" => "phones#user", as: "user_phone"

  resources :phones, only: [:index, :edit, :update, :show] do
    post "sync", on: :collection
    get "zero", on: :collection
  end

  root to: "application#front_door_redirect"
end
