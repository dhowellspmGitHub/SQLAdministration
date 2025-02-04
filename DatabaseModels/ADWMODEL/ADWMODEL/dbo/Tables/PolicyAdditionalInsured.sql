CREATE TABLE [dbo].[PolicyAdditionalInsured] (
    [PolicyAdditionalInsuredId] BIGINT        NOT NULL,
    [PolicyId]                  INT           NULL,
    [PolicyNbr]                 VARCHAR (16)  NOT NULL,
    [AdditionalInsuredTypeDesc] VARCHAR (200) NOT NULL,
    [FirstNm]                   CHAR (20)     NOT NULL,
    [LastNm]                    CHAR (70)     NOT NULL,
    [AddressLine1Desc]          VARCHAR (100) NOT NULL,
    [AddressLine2Desc]          VARCHAR (100) NOT NULL,
    [AddressLine3Desc]          VARCHAR (100) NOT NULL,
    [CityNm]                    CHAR (30)     NOT NULL,
    [StateOrProvinceCd]         CHAR (3)      NOT NULL,
    [ZipCd]                     CHAR (9)      NOT NULL,
    [AddressTypeCd]             VARCHAR (25)  NOT NULL,
    [MaritalStatusCd]           CHAR (1)      NOT NULL,
    [BirthDt]                   DATE          NOT NULL,
    [GenderCd]                  CHAR (1)      NOT NULL,
    [RelationshipDesc]          VARCHAR (50)  NOT NULL,
    [MemberInterestDesc]        VARCHAR (255) NULL,
    [CompanyNm]                 VARCHAR (512) NULL,
    [CreatedTmstmp]             DATETIME      NOT NULL,
    [UserCreatedId]             CHAR (8)      NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyAdditionalInsured] PRIMARY KEY CLUSTERED ([PolicyAdditionalInsuredId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyAdditionalInsured_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyAdditionalInsured_01]
    ON [dbo].[PolicyAdditionalInsured]([PolicyId] ASC)
    ON [POLICYCI];

