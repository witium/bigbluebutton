package org.bigbluebutton.lib.user.services {
	
	import org.bigbluebutton.lib.main.commands.DisconnectUserSignal;
	import org.bigbluebutton.lib.main.models.IConferenceParameters;
	import org.bigbluebutton.lib.main.models.IMeetingData;
	import org.bigbluebutton.lib.main.models.IUserSession;
	import org.bigbluebutton.lib.user.models.EmojiStatus;
	import org.bigbluebutton.lib.user.models.User;
	
	public class UsersService implements IUsersService {
		
		[Inject]
		public var conferenceParameters:IConferenceParameters;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var meetingData:IMeetingData;
		
		[Inject]
		public var disconnectUserSignal:DisconnectUserSignal;
		
		public var usersMessageSender:UsersMessageSender;
		
		public var usersMessageReceiver:UsersMessageReceiver;
		
		public function UsersService() {
			usersMessageSender = new UsersMessageSender;
			usersMessageReceiver = new UsersMessageReceiver;
		}
		
		public function setupMessageSenderReceiver():void {
			usersMessageReceiver.userSession = userSession;
			usersMessageReceiver.meetingData = meetingData;
			usersMessageReceiver.conferenceParameters = conferenceParameters;
			usersMessageReceiver.disconnectUserSignal = disconnectUserSignal;
			usersMessageSender.userSession = userSession;
			usersMessageSender.conferenceParameters = conferenceParameters;
			userSession.mainConnection.addMessageListener(usersMessageReceiver);
			userSession.logoutSignal.add(logout);
		}
		
		public function muteMe():void {
			mute(userSession.userList.me);
		}
		
		public function unmuteMe():void {
			unmute(userSession.userList.me);
		}
		
		public function mute(user:User):void {
			muteUnmute(user, true);
		}
		
		public function unmute(user:User):void {
			muteUnmute(user, false);
		}
		
		private function muteUnmute(user:User, mute:Boolean):void {
			if (user.voiceJoined) {
				usersMessageSender.muteUnmuteUser(user.userId, mute);
			}
		}
		
		public function addStream(userId:String, streamName:String):void {
			usersMessageSender.addStream(userId, streamName);
		}
		
		public function removeStream(userId:String, streamName:String):void {
			usersMessageSender.removeStream(userId, streamName);
		}
		
		public function logout():void {
			userSession.logoutSignal.remove(logout);
			disconnect(true);
		}
		
		public function disconnect(onUserAction:Boolean):void {
			userSession.mainConnection.disconnect(onUserAction);
		}
		
		public function emojiStatus(status:String):void {
			usersMessageSender.emojiStatus(userSession.userList.me.userId, status);
		}
		
		public function clearUserStatus(userId:String):void {
			usersMessageSender.emojiStatus(userId, EmojiStatus.NO_STATUS);
		}
		
		public function kickUser(userId:String):void {
			usersMessageSender.kickUser(userId);
		}
		
		public function queryForParticipants():void {
			usersMessageSender.queryForParticipants();
		}
		
		public function assignPresenter(userId:String, name:String):void {
			usersMessageSender.assignPresenter(userId, name, meetingData.users.me.intId);
		}
		
		public function queryForRecordingStatus():void {
			usersMessageSender.queryForRecordingStatus();
		}
		
		public function changeRecordingStatus(userId:String, recording:Boolean):void {
			usersMessageSender.changeRecordingStatus(userId, recording);
		}
		
		public function muteAllUsers(mute:Boolean):void {
			usersMessageSender.muteAllUsers(mute);
		}
		
		public function muteAllUsersExceptPresenter(mute:Boolean):void {
			usersMessageSender.muteAllUsersExceptPresenter(mute);
		}
		
		public function muteUnmuteUser(userId:String, mute:Boolean):void {
			usersMessageSender.muteUnmuteUser(userId, mute);
		}
		
		public function ejectUser(userId:String):void {
			usersMessageSender.ejectUser(userId);
		}
		
		public function getRoomMuteState():void {
			usersMessageSender.getRoomMuteState();
		}
		
		public function getRoomLockState():void {
			usersMessageSender.getRoomLockState();
		}
		
		public function setAllUsersLock(lock:Boolean, except:Array = null):void {
			usersMessageSender.setAllUsersLock(lock, except);
		}
		
		public function setUserLock(internalUserId:String, lock:Boolean):void {
			usersMessageSender.setUserLock(internalUserId, lock);
		}
		
		public function getLockSettings():void {
			usersMessageSender.getLockSettings();
		}
		
		public function saveLockSettings(newLockSettings:Object):void {
			usersMessageSender.saveLockSettings(newLockSettings);
		}
		
		public function validateToken():void {
			usersMessageSender.validateToken(conferenceParameters.internalUserID, conferenceParameters.authToken);
		}
		
		public function joinMeeting():void {
			usersMessageSender.joinMeeting();
		}
	}
}
