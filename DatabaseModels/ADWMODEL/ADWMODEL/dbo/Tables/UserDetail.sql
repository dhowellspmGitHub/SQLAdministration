﻿CREATE TABLE [dbo].[UserDetail] (
    [UserDetailId]            INT            NOT NULL,
    [UserMasterId]            INT            NOT NULL,
    [UserID]                  VARCHAR (20)   NOT NULL,
    [UserIDDesc]              VARCHAR (255)  NULL,
    [FirstNm]                 CHAR (20)      NULL,
    [MiddleNm]                CHAR (20)      NULL,
    [LastNm]                  CHAR (70)      NULL,
    [OfficePhoneNbr]          CHAR (16)      NULL,
    [OfficePhoneExtensionNbr] CHAR (6)       NULL,
    [MailStopNm]              VARCHAR (10)   NULL,
    [EffectiveDt]             DATE           NULL,
    [ExpirationDt]            DATE           NULL,
    [MobilePhoneNbr]          CHAR (16)      NULL,
    [FaxNbr]                  CHAR (20)      NULL,
    [EmailAddressDesc]        CHAR (40)      NULL,
    [JobTitleDesc]            VARCHAR (200)  NULL,
    [BadgeNbr]                INT            NULL,
    [SupervisorId]            CHAR (8)       NULL,
    [DepartmentNm]            CHAR (50)      NULL,
    [ADGroupDesc]             VARCHAR (3000) NULL,
    [CurrentRecordInd]        BIT            NOT NULL,
    [WebSiteDesc]             VARCHAR (1000) NULL,
    [SocialMediaDesc]         VARCHAR (1000) NULL,
    [ProfessionalTitleDesc]   VARCHAR (200)  NULL,
    [UpdatedTmstmp]           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]           CHAR (8)       NOT NULL,
    [LastActionCd]            CHAR (1)       NOT NULL,
    [SourceSystemCd]          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UserDetail] PRIMARY KEY CLUSTERED ([UserDetailId] ASC),
    CONSTRAINT [FK_UserDetail_UserMaster_01] FOREIGN KEY ([UserMasterId]) REFERENCES [dbo].[UserMaster] ([UserMasterId])
);

