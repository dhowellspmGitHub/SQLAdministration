CREATE TABLE [dbo].[Endorsements] (
    [EndorsementId]                  INT           NOT NULL,
    [EndorsementNbr]                 CHAR (10)     NOT NULL,
    [CurrentRecordInd]               BIT           NOT NULL,
    [EndorsementDesc]                VARCHAR (100) NULL,
    [EndorsementEditionYearDt]       DATE          NULL,
    [LineofBusinessCd]               CHAR (2)      NULL,
    [EndorsementEffectiveDt]         DATE          NULL,
    [EndorsementExpiryDt]            DATE          NULL,
    [EndorsementAppliedToCoverageCd] CHAR (3)      NULL,
    [EndorsementMailFlagInd]         CHAR (1)      NULL,
    [EndorsementRateCd]              CHAR (2)      NULL,
    [EndorsementLegalDesc]           VARCHAR (250) NULL,
    [UpdatedTmstmp]                  DATETIME2 (7) NOT NULL,
    [SourceSystemCd]                 CHAR (2)      NOT NULL,
    [LastActionCd]                   CHAR (1)      NOT NULL,
    [UserUpdatedId]                  CHAR (8)      NOT NULL,
    CONSTRAINT [PK_Endorsements] PRIMARY KEY CLUSTERED ([EndorsementId] ASC)
);

