Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  get '/test/:id', 'tests#show'
end
