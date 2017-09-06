class Api::V1::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user!
  before_filter :get_event , only: [:update_event, :view_event, :delete_event]
  
  def index
    @events  = Event.all
    if !@events.blank?
      render :json => {
        :success => true,
        :events => @events
      }
    else
      render :json => {
        :success => false,
        :message => "There Are No Event Present"
        }, :status => 400
      end
    end


    def create 

      puts "1111111111111111111111111111111111111111111111111111111111111111111111111"
      puts params[:event][:avatar][0, 500]
      puts "2222222222222222222222222222222222222222222222222222222222222222222222222"
      

      if params[:event]
        @event  = Event.new(event_params)

        if @event.save

          if params[:event][:avatar]

            #base64_url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHQAAACXCAIAAABLKOhcAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAABMAAAAKAAAAEwAAABLAAAFtrujwQcAAAWCSURBVHgB7Jm9L25LGMXf6ysUotApJCQ6IhIREUSjIxKNiH9AqBQKhUqpIFGrVISCErXofCSi8JGIRIiEAvF9zl0565yVyfaee3j3PPvd997ZxWTN7L2feeY3a2bPS+Z7uMwIZMwih8DfA1xDEwS4Aa4hAcPQwbkBriEBw9DBuQGuIQHD0MG5Aa4hAcPQwbkBriEBw9DBuQGuIQHD0MG5Aa4hAcPQwbkBriEBw9DBuQGuIQHD0MG5Aa4hAcPQwbkBriEBw9DBuQGuIQHD0MG5Aa4hAcPQwbkBriEBw9DBuQGuIQHD0MG5Aa4hAcPQwbkBriEBw9DBuQGuIQHD0MG5/3u4335cwoCaNISqekwt7mPJ65Q616UT0aq6glotyXPM2mPq4AqQBPKWfn9/5zDYoqrb6D7P9nyV6YULIm9vb+QCiKT5O8p8DHd15Quo228a4QqlmyhBg13ErXiGQN2HU6LTBReYyAXi9fWVVbHT3X/mq8fyjjhFcAkRpcvu6enp+vr6+Pj49PT07Ozs/v5eyAhRW4eYMo4ey6NIC1wSQbm1tTU9PT04ONjS0lJRUZHJZAoKCv76daFaWFhYV1fX09MzPj6+srJye3v7kW8egbpdm8OVodir60rl8fDwsLi42NvbW15eDnxfuoC+qalpamrq5OQEASPxI72rx2SEOVwOA4OMDBvtcBwW+/DwMJjCj2AKg36JrPswInR0dKyuriKsmFKgpJDH/1NwNRgN8uDgYGhoiExRxsEKxJobxGloaFhYWECPnM4fYH8WSiMZYe5c0sRg8PVHCe/c3d1huywpKSERrGsakFXXjJ/UmhgJxGxtbd3Z2SFE5ZAMU/WSHFyu1o2NjerqalETjqKiIjQKtB74o+ArkTh8CzExizhvaLQftybdshDmcJk0N7vJyUmXBYmgRCPb/4jy4wN4nRODW0IMQY2yra0NJzmmkbCFzeFyt8NW0NXVhfFH1r5bBYicESsOI4gsJ6OyshIrJmGymE5zuOjj4uKisbFR4CIjx/hz3hPwLqIpoASZskpdVla2tLRE/yZWeoMrX3Bv1QDOz89ra2tJgeNMssSMalLh7vn5eebJbUo5K1u/widcZsz8+Om4ubmpr68HTS3bJCnLuRDUSGNtbQ25ASsvvzQj0bzBVVwkTf34+Nje3u6SlYkSMC9pskdqlqWlpdvb28zQPQgrf4/CM1ymSwuPjo66EF3zuu2mmkDRBQQ1yqqqqsvLS0G0s7A3uDIsyS4vL5MahySyOjaZMnW7Li4uVl9aOt3d3YBLK4iyd+ENLjIDX6aL4wH/oEWyGBvhqqpBathGQtsChfpFJjMzM8j55eXFO1MF9AbXdcHAwABg0TICihZqt8WIKcJqrag7CuHG9OMkQxDup1ho4gtvcJEKXbC5uRkZDwnKNai6OgG+6EIpQYs7/mqMtF1bxAfqRvAGl3suyubm5sTw5TYx2qNAfHd318XhV3uDi7RgAde2MkhuCEzf0ne1v7/fL1A3mje4XFydnZ0pt607Z3AuPgyHh4c66rho4mufcI+OjpA6DZvMruqS+qQGUC0pbsRjY2PxOWaN4A0uok9MTLgjROrM3m1MidaZARniN4XRgcwbXJxmampqwA55p5Yp00PJDLW88KnIar2Yjd7g7u3tKXUILT3otF0iS7hIFb/UY3LM+ro3uHNzc4IoR6glPQJkCRcpSeNPd1npxGyMBVc/bHBU6OvrU65EGammh2/WTK6urogSJwdfh4dc4KpvCaTFDZemSLNzs5JF4/r6+vPzs2vV+L/ccoGLDNQx+eJfZATKkohZ/m4waWufnZ0VWQwKl9al2r8qcoSLvtUT9P7+PmEBLvmi+u+COzIyohFRuGOM3Ppk9W8AAAD//02NbNEAAAaESURBVO2aP0hcSxjFNf5ptBLRQgvFTgIStVACphBsFCsLRUkRsBO00M7Cxs5GBcE6aBlBQkQUUgQLKxEsBEELIdEoghIQ/PfecY/vvHnjKu7uzO74mFuM3517d77z/ebM7PWyeX9lcNzd3eHTt7e3X79+zc/Pz0scb968wV+dsjP8tqurC7Xc3NxkwMP+aJ7d8YJzMsWNCj5//mzhe3WI29raUBGMghaIGbwAxnO3pAMX4wkrg/n5ebqVhpVtidjiHubpu3fvVNRzwFK5ljJcKkDLgLmmp6dNZK/OthD/9u1bVgTPMrivMLHvpcLzP/emCVdjID3U0LniG7Jhsaq0sCiYp01NTW43XCBKGS4+83g+FxYWKDFkrCZKxJbUDx8+0DH3dk04Bi170m7TgavNnunRfvv2jXBlCutUpg4kKCgoEGtIBWg8LWRO05qGjOBqqre3ty1qhGu5w7onV6dSBZHUCSVDQ0Msh9ZxAjoduEws/0LTxcUFFbOV4lzhe0leiJRaBDMzMyZcxJnzTQcuE1u5q6urURKXW/hwRRaaiXhtbS33X2gWU5zSwr29vRBKrGoDpCxtdDfJoj0+PqZzVZG5NHkp1TZN50qH8mFZUSjUM6D6MFsxhTzEDQ0NKkSBZSP1vzzICK6ZZmdnhxwtawQIlwoLCwuhjfHw8LBZi6vYGVwIqq2tFUqKDtbCFKYHMmy4roCa47iEOz4+DqbQTekCHVogz1JnVVWVScRh7Awuvmr39vYCx4pplls15WNjY5lvr0mnxBlcjt7e3g7R3BPMQJUEEnCFQUxRUdHu7m5SNJl3OoPLB5f19XUo5roLhOMzMoC4r68PEDN/6ko6E87gcmVBJd6APFNPzi9pVXEHwz/unvYE4HYGF2NR5ffv37GvqYac00wqgGQ/fvxIx3ni6wwu9EniwMAASrL4Pv4mSVq2807KQKuAKcrKyn7+/Am4nvYEx86leYEY/0pCOmqAQViSniJ4mh3QSmoGFABtc3NzEMz3Cc7fKmBkHM6cy+HQ0r9LS0sqybIMClOFNJGPltmRSIGSYmq7u7sJ9H65ZfxSXLVbgUu4lMtVhnh0dNSipqd3q9/3qaaZK6ampub09FRYXwFcGUHm/fPnT0dHB8DBMjl5OGNSkaVzS0pKNjc3ZTFawdO269K5wqrg7OysubmZxtQ+i5q1QrPjWe0MxcXFq6urkkfP0hbC7TBwDBfK5AIGR0dH9fX1oJk1oJwwphNWdGJSFxcXqcrcCrQ/OMTKoVzCpWJLN9L8/v27paUF5ZkF+/as0jFpaWnp8vKy8D2WqksOA5dwn5KFSrD/dnZ2mkBZs/YKBuw0bzNjXkWrwCJo3oxYu21lZeWPHz8gz5z4p9Q67M8GXMjlYpycnNQ3GwFZdBLcHtiRjsWRNxCiJsZc+7zfJPv+/fvDw0Mi05blkOAzQ3mHC7Nom0O8sbFRV1dHOmjJQpiEUqYTLH1EgS7xZrQMMBoDTCReMSt7lskCune4mliQxYHTy8vLiYkJfHEDk7AiUIx+0LHY4VQ9uJNxou/hp6v4lDoR4ymQ7xKRFFiZWmKyE2QJ7vX1NethnSh1f39/cHAQr1MBwjxMxKKpG6wenSLQhtPY2IjvLqRAUrqVLR65GGSHLLJ4h4sicbCeq6srFcb+X79+jYyM4AuHmLichUxM2Y9TXbr3eeInSejhgav4SZL5GKtcCLKMlam9w0UacJRzzTpZMC7BU1++fOnv7y8vLxdfsAM18WXAHrMf3m9tbZ2amjo5OeGEKQUn1UzNHlaehTYbcFkGUbJNWiTRbG1tzc7Ofvr0CS/dKyoqTLeSKf5/xc8Menp6sHGvrKzgIY+jaXwGYqdcCnTJd5A9uClVIhAw9fn5OV68Hhwc4G2LubGkNGBObg4UrsXCNCO44xSHJsC6OZzTcOGCHQ/B+qfj398ko0dXAwyCg5uUV9JO0HyqPxDQwcElF1ALHNxL5i9QuJIOxNpeE8Af9gH245LuDDAIDq5J8DGv568+vj+3PcHBBQ4SRKvYDMjr/nEhbNtCZ4hwie9/0Ea4Hicxwo1wPRLwOHR0boTrkYDHoaNzI1yPBDwOHZ0b4Xok4HHo6NwI1yMBj0NH50a4Hgl4HDo6N8L1SMDj0NG5Ea5HAh6Hjs6NcD0S8Dh0dG6E65GAx6GjcyNcjwQ8Dh2dG+F6JOBx6OjcCNcjAY9DR+dGuB4JeBw6Otcj3L8B1n12aWSPGkAAAAAASUVORK5CYII="
            base64_url = params[:event][:avatar]

            start = base64_url.index ';base64,'
            content_type = base64_url[5..start-1]
            encoded_picture = base64_url[(start+8)..-1]

            image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
            image.original_filename = "test.png"
            @event.update_attributes(:avatar => image)
          end

          if params[:event][:playlist_id]
            playlist = Playlist.find_by(id: params[:event][:playlist_id])
            if playlist.present?
              events_playlists = EventsPlaylists.find_by(event_id: @event.id, playlist_id: playlist.id)
              unless events_playlists.present?
                events_playlists = EventsPlaylists.create(event_id: @event.id, playlist_id: playlist.id)
              end
            end
          end

          render :event
        else
          render :json => {
            :success => false,
            :message => @event.errors.full_messages.to_sentence
            }, :status => 400
          end
        else
          render :json => {
            :success => false,
            :message => "Check Params"
            }, :status => 400
          end
        end


        def view_event
          if !@event.blank?
            render :event
          else
            render :json => {
              :success => false,
              :message => "Event was not found"
              }, :status => 400
            end
          end


          def update
            if !@event.blank?
              if @event.update(event_params)

                if params[:event][:avatar]
                 base64_url = "data:image/png;base64,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"
                 #base64_url = params[:event][:avatar]

                 start = base64_url.index ';base64,'
                 content_type = base64_url[5..start-1]
                 encoded_picture = base64_url[(start+8)..-1]

                 image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
                 image.original_filename = "test.png"
                 @event.update_attributes(:avatar => image)
               end

               if params[:event][:playlist_id]
                playlist = Playlist.find_by(id: params[:event][:playlist_id])
                if playlist.present?
                  old_playlist = EventsPlaylists.find_by(event_id: @event.id)
                  old_playlist.destroy
                  events_playlists = EventsPlaylists.find_by(event_id: @event.id, playlist_id: playlist.id)
                  unless events_playlists.present?
                    events_playlists = EventsPlaylists.create(event_id: @event.id, playlist_id: playlist.id)
                  end
                end
              end

              render :event
            else
              render :json => {
                :success => false,
                :message => @event.errors.full_messages.to_sentence
                }, :status => 400
              end
            else
              render :json => {
                :success => false,
                :message => "Unable To Find Event"
                }, :status => 400
              end
            end

            def update_event
              if !@event.blank?
                if @event.update(event_params)

                  if params[:event][:playlist_id]
                    playlist = Playlist.find_by(id: params[:event][:playlist_id])
                    if playlist.present?
                      old_playlist = EventsPlaylists.find_by(event_id: @event.id)
                      old_playlist.destroy
                      events_playlists = EventsPlaylists.find_by(event_id: @event.id, playlist_id: playlist.id)
                      unless events_playlists.present?
                        events_playlists = EventsPlaylists.create(event_id: @event.id, playlist_id: playlist.id)
                      end
                    end
                  end

                  render :event
                else
                  render :json => {
                    :success => false,
                    :message => @event.errors.full_messages.to_sentence
                    }, :status => 400
                  end
                else
                  render :json => {
                    :success => false,
                    :message => "Unable To Find Event"
                    }, :status => 400
                  end
                end



                def delete_event
                  if @event && @event.destroy
                    render :json => {
                      :message => "Event Deleted.", 
                      :success => true
                    }
                  else
                    render :json => {
                      :message => "Event Not Found.", 
                      :success => false
                      }, :status => 400
                    end
                  end


                  def upcoming_events
                    offset_value = params[:offset].to_i * 10
                    @events  = Event.where("start_time >= ?", Date.today).limit(10).offset(offset_value).order("start_time ASC")

                    if @events.present?
                      render :events
                    else
                      render :json => {
                        :message => "Events Not Found.", 
                        :success => false
                        }, :status => 400
                      end
                    end

                    def my_events
                      if params[:id].present?
                        @user = User.find_by_id(params[:id])
                        if @user.present?
                          @events  = @user.events
                          if @events.present?
                            render :events
                          else
                            render :json => {
                              :message => "Events Not Found.", 
                              :success => false
                              }, :status => 400
                            end
                          else
                            render :json => {
                              :message => "User Not Found.", 
                              :success => false
                              }, :status => 400
                            end
                          else
                            render :json => {
                              :message => "Check Parameters!", 
                              :success => false
                              }, :status => 400
                            end
                          end


                          private 

                          def event_params
                            params.require(:event).permit(:user_id, :name, :start_time, :venu_name, :address, :zip_code, :end_time, :price, :trainers_allowed, :upload_flyer, :playlist_tag, :longitude, :latitude)
                          end

                          def get_event
                            @event = Event.find_by_id(params[:id])
                          end
                        end
