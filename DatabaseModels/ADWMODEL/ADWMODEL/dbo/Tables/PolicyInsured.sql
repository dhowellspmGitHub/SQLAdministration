CREATE TABLE [dbo].[PolicyInsured] (
    [PolicyId]                              INT           NOT NULL,
    [PolicyNbr]                             VARCHAR (16)  NOT NULL,
    [LineofBusinessCd]                      CHAR (2)      NOT NULL,
    [PrimaryInsuredNbr]                     CHAR (10)     NULL,
    [PrimaryInsuredName]                    VARCHAR (100) NULL,
    [PrimaryInsuredBirthDt]                 DATE          NULL,
    [PrimaryInsuredExemptEmployeeInd]       CHAR (2)      NULL,
    [SecondaryInsuredNbr]                   CHAR (10)     NULL,
    [SecondaryInsuredNm]                    VARCHAR (100) NULL,
    [SecondaryInsuredBirthDt]               DATE          NULL,
    [SecondaryInsuredExemptEmployeeInd]     CHAR (2)      NULL,
    [MailingStreetAddress1Txt]              CHAR (35)     NULL,
    [MailingStreetAddress2Txt]              CHAR (35)     NULL,
    [MailingCityNm]                         CHAR (30)     NULL,
    [MailingZipCd]                          CHAR (9)      NULL,
    [MailingStateCd]                        CHAR (2)      NULL,
    [InsuredHomePhoneNbr]                   CHAR (16)     NULL,
    [InsuredWorkPhoneNbr]                   CHAR (16)     NULL,
    [InsuredEmailAddressDesc]               VARCHAR (100) NULL,
    [DoingBusinessAsNm]                     CHAR (30)     NULL,
    [PolicyDeclaration1Nm]                  VARCHAR (100) NULL,
    [PolicyDeclaration2Nm]                  VARCHAR (100) NULL,
    [LongNameInd]                           CHAR (1)      NULL,
    [TotalDriversCnt]                       INT           NULL,
    [MembershipNbr]                         CHAR (10)     NULL,
    [InsuranceScoreNbr]                     DECIMAL (5)   NULL,
    [InsuranceScoreDt]                      DATE          NULL,
    [InsuranceScorePartyNbr]                CHAR (10)     NULL,
    [InsuranceScoreInsuredRelationshipDesc] VARCHAR (50)  NULL,
    [UpdatedTmstmp]                         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                         CHAR (8)      NOT NULL,
    [LastActionCd]                          CHAR (1)      NOT NULL,
    [SourceSystemCd]                        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyInsured] PRIMARY KEY CLUSTERED ([PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyInsured_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyInsured_01]
    ON [dbo].[PolicyInsured]([PolicyNbr] ASC)
    ON [POLICYCI];

