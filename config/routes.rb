Centraal::Application.routes.draw do
  match "/dispatchers/receive_call" => "dispatchers#receive_call", :as => :receive_call
  match "/dispatchers/conclude_call" => "dispatchers#conclude_call", :as => :conclude_call
  match "/dispatchers/receive_voicemail" => "dispatchers#receive_voicemail", :as => :receive_voicemail
  match "/dispatchers/receive_voicemail_transcription" => "dispatchers#receive_voicemail_transcription", :as => :receive_voicemail_transcription, :via => :post

  resources :phone_numbers, :only => [:index, :edit, :update] do
    post "import", :on => :collection
  end

  root :to => redirect("/phone_numbers")
end
