CREATE TABLE [dbo].[PolicyMembershipTransfer] (
    [PolicyMembershipTransferId] INT           IDENTITY (1, 1) NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [MembershipNbr]              CHAR (10)     NOT NULL,
    [MultiVehcileDiscountDesc]   VARCHAR (50)  NULL,
    [ActiveAutoDiscountDesc]     VARCHAR (50)  NULL,
    [ActivePropertyDiscountDesc] VARCHAR (50)  NULL,
    [PolicyFormCd]               VARCHAR (10)  NULL,
    [OriginalInceptionDt]        DATE          NULL,
    [TransferMembershipNbr]      CHAR (10)     NULL,
    [TransferPolicyNbr]          VARCHAR (16)  NULL,
    [TransferTmstmp]             DATETIME      NOT NULL,
    [PolicyEffectiveDt]          DATE          NOT NULL,
    [CreatedTmstmp]              DATETIME      NOT NULL,
    [UserCreatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyMembershipTransfer] PRIMARY KEY CLUSTERED ([PolicyMembershipTransferId] ASC) ON [POLICYCD]
) ON [POLICYCD];

