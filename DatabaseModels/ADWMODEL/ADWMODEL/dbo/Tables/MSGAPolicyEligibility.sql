CREATE TABLE [dbo].[MSGAPolicyEligibility] (
    [OriginalAgentNbr]                  CHAR (4)      NOT NULL,
    [ValidationAgentNbr]                CHAR (4)      NOT NULL,
    [PolicyNbr]                         VARCHAR (16)  NOT NULL,
    [TransferEffectiveDt]               DATE          NOT NULL,
    [TransferExpirationDt]              DATE          NOT NULL,
    [InitialBookOfBusinessInd]          BIT           NOT NULL,
    [PermanentInitialBookOfBusinessInd] BIT           NOT NULL,
    [PostInitialBookOfBusinessInd]      BIT           NOT NULL,
    [ValidationCntEligibilityInd]       BIT           NOT NULL,
    [CashUpdatedInd]                    BIT           NOT NULL,
    [CreatedTmstmp]                     DATETIME      NOT NULL,
    [UserCreatedId]                     CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL
) ON [AGENCYCD];

