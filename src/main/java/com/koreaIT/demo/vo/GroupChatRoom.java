package com.koreaIT.demo.vo;

import java.util.HashMap;
import java.util.UUID;

import lombok.Data;

@Data
public class GroupChatRoom {
    private int id; // 채팅방 아이디
    private int groupChatRoomProjectId; // 식별 ID
    private String name; // 채팅방 이름
}
