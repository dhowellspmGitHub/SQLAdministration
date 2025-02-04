CREATE TABLE [dbo].[AdditionalInterest] (
    [AdditionalInterestId]             INT           NOT NULL,
    [AdditionalInterestNbr]            CHAR (10)     NOT NULL,
    [CurrentRecordInd]                 BIT           NOT NULL,
    [AdditionalInterestRelationshipCd] CHAR (1)      NOT NULL,
    [AdditionalInterestAlternateNbr]   CHAR (10)     NULL,
    [AdditionalInterestNm]             CHAR (40)     NULL,
    [AdditionalInterest2Nm]            CHAR (40)     NULL,
    [AdditionalInterestAddressTxt]     CHAR (30)     NULL,
    [AdditionalInterestCityNm]         CHAR (30)     NULL,
    [AdditionalInterestStateCd]        CHAR (2)      NULL,
    [AdditionalInterestZipCd]          CHAR (9)      NULL,
    [UpdatedTmstmp]                    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                    CHAR (8)      NOT NULL,
    [LastActionCd]                     CHAR (1)      NOT NULL,
    [SourceSystemCd]                   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdditionalInterest] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC)
);

